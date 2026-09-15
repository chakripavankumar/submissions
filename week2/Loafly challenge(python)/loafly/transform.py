from loafly.models import Order

def clean_price(text):
    if not text or text == "":
        return 0.0
    return float(str(text).strip().replace(",", ""))

def apply_discount(price, percent):
    return price - price * percent / 100

def transform_orders(rows, discount_percent):
    orders = {}
    
    for row in rows:
        oid = row.get("order_id")
        customer = row.get("customer")
        item_name = row.get("item_name")
        item_price_raw = row.get("item_price")
        
        if not oid or not item_price_raw:
            continue 
            
        if oid not in orders:
            orders[oid] = Order(oid, customer)
        
        cleaned_price = clean_price(item_price_raw)
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
        
    return transformed_data