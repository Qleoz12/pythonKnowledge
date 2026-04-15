"""Run all ETL scripts in sequence."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from database import engine
from models import Base
from logger import get_logger

log = get_logger("etl.pipeline")

log.info("=" * 60)
log.info("Stock Portfolio Unifier — ETL Pipeline")
log.info("=" * 60)

log.info("[1/3] Creating database tables...")
Base.metadata.create_all(bind=engine)

log.info("[2/3] Loading exchange features + dividend events...")
from etl.load_features import run as run_features
run_features()

from etl.load_div_events import run as run_div_events
run_div_events()

log.info("[3/3] Loading Quanfury data...")
from etl.load_quanfury import run as run_quanfury
run_quanfury()

log.info("=" * 60)
log.info("ETL pipeline complete!")
log.info("=" * 60)
