import time
import os
from concurrent.futures import ProcessPoolExecutor


# Must be at the top level so worker processes can access it
def score_genre(genre):
    score = 0

    # Simulate a CPU-heavy calculation
    for i in range(5_000_000):
        score += (i * len(genre)) % 97

    return (genre, score)


def main():
    genres = [
        "fiction",
        "fantasy",
        "science",
        "history",
        "mystery",
        "romance",
        "thriller",
        "biography"
    ]

    core_count = os.cpu_count()

    print(f"CPU cores: {core_count}")

    start = time.perf_counter()

    serial_results = [
        score_genre(genre)
        for genre in genres
    ]

    serial_time = time.perf_counter() - start

    start = time.perf_counter()

    with ProcessPoolExecutor() as pool:
        parallel_results = list(
            pool.map(score_genre, genres)
        )

    parallel_time = time.perf_counter() - start

    print("\nSerial results:")
    print(serial_results)

    print("\nParallel results:")
    print(parallel_results)

    print(f"\nSerial time:   {serial_time:.2f} seconds")
    print(f"Parallel time: {parallel_time:.2f} seconds")

    print(f"\nResults match: {serial_results == parallel_results}")


if __name__ == "__main__":
    main()