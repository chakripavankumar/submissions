from loafly.extract import extract_orders
from loafly.transform import transform_orders
from loafly.load import load_orders

def main():
    print("Starting configuration-driven pipeline...")
    
    # 1. Extract using config path
    raw_data = extract_orders()
    
    # 2. Transform using config discount
    processed_data = transform_orders(raw_data)
    
    # 3. Load using config retry count & currency
    load_orders(processed_data)
    
    print("Pipeline finished successfully!")

if __name__ == "__main__":
    main()