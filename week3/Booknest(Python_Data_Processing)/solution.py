import requests


def get_books(subject, page):
    url="https://openlibrary.org/search.json"
    
    params = {
        "q": subject,
        "page" : page,
        "limit": 10
    }
    
    
    try:
        responce = requests.get(url,params=params,timeout=15)
        responce.raise_for_status()
        
        data = responce.json()
        books = []
        
        for book in data.get("docs",[]):
            books.append({
                "title":book.get("title"),
                "author": book.get("author_name"),
                "first_publish_year": book.get("first_publish_year"),
                "rating": book.get("ratings_average")
            })

        return books
        
    except requests.RequestException as error:
         print(f"API request failed: {error}")
         return[]


if __name__ == "__main__":
    books = get_books("python", 1)

    for book in books[:5]:
        print(book)