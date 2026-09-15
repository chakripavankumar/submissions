import logging
from loafly.config import API_KEY, RETRY_COUNT, CURRENCY

logger = logging.getLogger("loafly.load")

def load_orders(transformed_orders):
    """Simulate loading/saving orders using logging instead of print."""
    for order in transformed_orders:
        success = False
        attempts = 0
        
        while not success and attempts < RETRY_COUNT:
            attempts += 1
            try:
                logger.info(f"Saving order {order['order_id']} for {order['customer']} — Total: {order['total']} {CURRENCY}")
                success = True
            except Exception as e:
                logger.warning(f"Attempt {attempts} failed to save order {order['order_id']}: {e}")
                if attempts >= RETRY_COUNT:
                    logger.error(f"Failed to save order {order['order_id']} after {RETRY_COUNT} attempts.")
                    raise e