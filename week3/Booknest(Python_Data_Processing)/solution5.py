import pandas as pd


# -------------------------
# 1. Stream the CSV
# -------------------------

revenue_by_genre = {}

for chunk in pd.read_csv("sales.csv", chunksize=50_000):

    # Revenue for each row
    chunk["revenue"] = chunk["price"] * chunk["quantity"]

    # Revenue by genre for this chunk
    chunk_revenue = chunk.groupby("genre")["revenue"].sum()

    # Add this chunk's totals to our running dictionary
    for genre, revenue in chunk_revenue.items():
        revenue_by_genre[genre] = (
            revenue_by_genre.get(genre, 0) + revenue
        )


print("Revenue by genre:")

for genre, revenue in revenue_by_genre.items():
    print(f"{genre}: {revenue:.2f}")


# -------------------------
# 2. Memory optimization
# -------------------------

# Read only one chunk
chunk = next(
    pd.read_csv("sales.csv", chunksize=50_000)
)

memory_before = chunk.memory_usage(deep=True).sum()


# Optimize data types
chunk["price"] = chunk["price"].astype("float32")
chunk["rating"] = chunk["rating"].astype("float32")

chunk["genre"] = chunk["genre"].astype("category")
chunk["city"] = chunk["city"].astype("category")
chunk["payment_type"] = chunk["payment_type"].astype("category")

memory_after = chunk.memory_usage(deep=True).sum()

print("\nMemory usage:")
print(f"Before: {memory_before / 1024**2:.2f} MB")
print(f"After:  {memory_after / 1024**2:.2f} MB")

reduction = (1 - memory_after / memory_before) * 100

print(f"Reduction: {reduction:.2f}%")