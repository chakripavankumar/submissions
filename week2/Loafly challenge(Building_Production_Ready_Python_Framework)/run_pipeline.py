import loafly.config 
import logging
from loafly.extract import extract_orders
from loafly.transform import transform_orders
from loafly.load import load_orders

logger = logging.getLogger("loafly.pipeline")

def main():
    logger.info("Pipeline execution started.")
    
    try:
        raw_data = extract_orders()
        processed_data = transform_orders(raw_data)
        load_orders(processed_data)
        logger.info("Pipeline execution completed successfully.")
    except Exception as e:
        logger.critical(f"Pipeline failed: {e}")
        raise

if __name__ == "__main__":
    main()