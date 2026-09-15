import logging
from loafly.models import Order
from loafly.config import DISCOUNT_PERCENT

logger = logging.getLogger("loafly.transform")

def clean_price(text):
    if not text or str(text).strip() == "":
        raise ValueError("Price field is empty or missing")
    cleaned = str(text).strip().replace(",", "").replace("$", "")
    return float(cleaned)

def apply_discount(price, percent=DISCOUNT_PERCENT):
    return price - price * percent / 100

def transform_orders(rows, discount_percent=DISCOUNT_PERCENT):
    orders = {}
    
    for row in rows:
        oid = row["order_id"]
        if oid not in orders:
            orders[oid] = Order(oid, row["customer"])
        
        item_name = row["item_name"]
        price_raw = row["item_price"]
        cleaned_price = None
        
        try:
            cleaned_price = clean_price(price_raw)
        except (ValueError, TypeError) as e:
            logger.warning(f"Skipping item '{item_name}' in order {oid} due to bad price '{price_raw}': {e}")
        finally:
            pass
        
        if cleaned_price is not None:
            orders[oid].add_item(item_name, cleaned_price)
    
    transformed_data = []
    for oid, order in orders.items():
        subtotal = sum(price for name, price in order.items)
        final_total = apply_discount(subtotal, discount_percent)
        transformed_data.append({
            "order_id": order.order_id,
            "customer": order.customer,
            "total": final_total
        })
        
    logger.info(f"Successfully transformed {len(transformed_data)} orders.")
    return transformed_data