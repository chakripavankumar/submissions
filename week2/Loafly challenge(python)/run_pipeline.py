from loafly.config import FILE_PATH, DEFAULT_DISCOUNT
from loafly.extract import extract_orders
from loafly.transform import transform_orders
from loafly.load import load_orders

def main():
    print("Starting pipeline...")
    
    # 1. Extract
    raw_data = extract_orders(FILE_PATH)
    
    # 2. Transform
    processed_data = transform_orders(raw_data, DEFAULT_DISCOUNT)
    
    # 3. Load
    load_orders(processed_data)
    
    print("Pipeline finished successfully!")

if __name__ == "__main__":
    main()
    