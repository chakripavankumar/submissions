from loafly.config import API_KEY, RETRY_COUNT, CURRENCY

def load_orders(transformed_orders):
    for order in transformed_orders:
        success = False
        attempts = 0
        
        while not success and attempts < RETRY_COUNT:
            attempts += 1
            try:
                print(f"[Attempt {attempts}/{RETRY_COUNT}] Saving order {order['order_id']} for {order['customer']} — Total: {order['total']} {CURRENCY}")
                success = True
            except Exception as e:
                if attempts >= RETRY_COUNT:
                    raise e