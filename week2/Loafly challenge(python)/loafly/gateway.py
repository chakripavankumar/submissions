import random
import logging

logger = logging.getLogger("loafly.gateway")

def save_to_orders_api(order_data, api_key):
    if random.random() < 0.3:
        raise ConnectionError("Gateway timeout or transient network glitch.")
    
    logger.info(f"API Gateway successfully saved Order {order_data['order_id']} using key prefix: {api_key[:6]}...")
    return True
