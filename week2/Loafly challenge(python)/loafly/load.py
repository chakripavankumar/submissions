import time
import logging
from loafly.config import API_KEY, RETRY_COUNT, RETRY_DELAY, CURRENCY
from loafly.gateway import save_to_orders_api

logger = logging.getLogger("loafly.load")

def load_orders(transformed_orders):
    for order in transformed_orders:
        success = False
        attempts = 0
        
        while not success and attempts < RETRY_COUNT:
            attempts += 1
            try:
                save_to_orders_api(order, API_KEY)
                success = True
                logger.info(f"Order {order['order_id']} loaded successfully — Total: {order['total']} {CURRENCY}")
            except Exception as e:
                logger.warning(f"Attempt {attempts}/{RETRY_COUNT} failed to save order {order['order_id']}: {e}")
                if attempts < RETRY_COUNT:
                    time.sleep(RETRY_DELAY)
                else:
                    logger.error(f"Giving up on order {order['order_id']} after {RETRY_COUNT} failed attempts.")