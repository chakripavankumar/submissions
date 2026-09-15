from loafly.models import Order
from loafly.config import DISCOUNT_PERCENT

def clean_price(text):
    if not text:
        return 0.0
    cleaned = text.strip().replace(",", "").replace("$", "")
    return float(cleaned)

def apply_discount(price, percent=DISCOUNT_PERCENT):
    return price - price * percent / 100

def transform_orders(rows, discount_percent=DISCOUNT_PERCENT):
    orders = {}
    
    for row in rows:
        oid = row["order_id"]
        if oid not in orders:
            orders[oid] = Order(oid, row["customer"])
        
        cleaned_price = clean_price(row["item_price"])
        orders[oid].add_item(row["item_name"], cleaned_price)
    
    transformed_data = []
    for oid, order in orders.items():
        subtotal = sum(price for name, price in order.items)
        final_total = apply_discount(subtotal, discount_percent)
        transformed_data.append({
            "order_id": order.order_id,
            "customer": order.customer,
            "total": final_total
        })
        
    return transformed_data