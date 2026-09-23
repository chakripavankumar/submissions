from solution import get_books

def full_load(subject, max_pages=5):
    all_books = []

    page = 1

    while page <= max_pages:
        books = get_books(subject, page)

        # Stop if the API returns an empty page
        if not books:
            break

        all_books.extend(books)
        page += 1

    return all_books


def get_watermark(books):
    years = [
        book["first_publish_year"]
        for book in books
        if book["first_publish_year"] is not None
    ]

    return max(years) if years else None


def incremental_load(books, watermark):
    return [
        book
        for book in books
        if book["first_publish_year"] is not None
        and book["first_publish_year"] > watermark
    ]


if __name__ == "__main__":
    # Full load
    books = full_load("python", max_pages=5)

    print(f"Full load count: {len(books)}")

    # Create watermark
    watermark = get_watermark(books)

    print(f"Watermark: {watermark}")

    # Simulate the next run
    new_books = incremental_load(books, watermark)

    print(f"Incremental books: {len(new_books)}")