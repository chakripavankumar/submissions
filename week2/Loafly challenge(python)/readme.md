# Loafly Python Assignment

Loafly pyhton assingnment/
│
├── .env                  # Local secrets (Git-ignored)
├── env.example           # Example environment template (Committed)
├── .gitignore            # Excludes secrets, logs, and venv
├── requirements.txt      # Project dependencies
├── README.md             # Documentation and virtual environment setup
├── raw_orders.csv        # Data source
├── run_pipeline.py       # Orchestrator runner
└── loafly/               # Package folder
    ├── __init__.py
    ├── config.py         # Reads from environment variables
    ├── models.py
    ├── extract.py
    ├── transform.py
    ├── gateway.py        # External API gateway simulation
    └── load.py           # Handles retries and loading
