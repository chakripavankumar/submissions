from loafly.config import API_KEY

def load_orders(transformed_orders):
    for order in transformed_orders:
        print(f"saving order {order['order_id']} for {order['customer']} total {order['total']} (Using API Key: {API_KEY[:6]}...)")