import requests
import asyncio
import time


def fetch(subject):
    url = "https://openlibrary.org/search.json"

    params = {
        "q": subject,
        "limit": 1
    }

    try:
        response = requests.get(url, params=params, timeout=15)
        response.raise_for_status()

        data = response.json()

        return data.get("numFound", 0)

    except requests.RequestException as error:
        print(f"Failed to fetch '{subject}': {error}")
        return 0


def sync_fetch(subjects):
    results = []

    for subject in subjects:
        count = fetch(subject)
        results.append((subject, count))

    return results


async def async_fetch(subjects):
    tasks = [
        asyncio.to_thread(fetch, subject)
        for subject in subjects
    ]

    results = await asyncio.gather(*tasks)

    return list(zip(subjects, results))


if __name__ == "__main__":

    subjects = [
        "python",
        "java",
        "sql",
        "docker",
        "linux"
    ]

    start = time.perf_counter()
    sync_results = sync_fetch(subjects)
    sync_time = time.perf_counter() - start

    start = time.perf_counter()
    async_results = asyncio.run(async_fetch(subjects))
    async_time = time.perf_counter() - start

    print("\nSync results:")
    print(sync_results)

    print("\nAsync results:")
    print(async_results)

    print(f"\nSync time:  {sync_time:.2f} seconds")
    print(f"Async time: {async_time:.2f} seconds")