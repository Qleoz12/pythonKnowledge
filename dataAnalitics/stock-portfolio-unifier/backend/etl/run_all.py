"""Run all ETL scripts in sequence."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from database import engine
from models import Base

print("=" * 60)
print("Stock Portfolio Unifier — ETL Pipeline")
print("=" * 60)

print("\n[1/3] Creating database tables...")
Base.metadata.create_all(bind=engine)

print("\n[2/3] Loading exchange features + dividend events...")
from etl.load_features import run as run_features
run_features()

from etl.load_div_events import run as run_div_events
run_div_events()

print("\n[3/3] Loading Quanfury data...")
from etl.load_quanfury import run as run_quanfury
run_quanfury()

print("\n" + "=" * 60)
print("ETL pipeline complete!")
print("=" * 60)
