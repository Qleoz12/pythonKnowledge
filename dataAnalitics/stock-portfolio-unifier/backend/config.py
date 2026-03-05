import os

BASE_DIR = os.path.dirname(__file__)
DATA_DIR = os.environ.get("DATA_DIR", os.path.join(BASE_DIR, "..", ".."))
DB_PATH = os.environ.get("DATABASE_PATH", os.path.join(BASE_DIR, "stock_unifier.db"))
DATABASE_URL = f"sqlite:///{DB_PATH}"
CORS_ORIGINS = os.environ.get("CORS_ORIGINS", "*").split(",")
