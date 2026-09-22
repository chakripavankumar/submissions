# Loafly Python Assignment

A clean, object-oriented, configuration-driven ETL (Extract, Transform, Load) pipeline built for processing customer orders. This project features modular architecture, fault-tolerant error handling, automatic retry mechanisms, and secure environment-variable management.

---

## Project Directory Structure

```text
Loafly Python Assignment/
├── .env                # Local secrets (Git-ignored)
├── env.example         # Example environment template (Committed)
├── .gitignore          # Excludes secrets, logs, and virtual environments
├── requirements.txt    # Project dependencies
├── README.md           # Project documentation and setup guide
├── raw_orders.csv      # Source data file
├── run_pipeline.py     # Main pipeline orchestration runner
└── loafly/             # Core package folder
    ├── __init__.py     # Package initialization
    ├── config.py       # Configuration and environment management
    ├── models.py       # Data structures (Order class)
    ├── extract.py      # Data extraction module
    ├── transform.py    # Data transformation and cleaning logic
    ├── gateway.py      # External API gateway simulation
    └── load.py         # Data loading with retry mechanisms
