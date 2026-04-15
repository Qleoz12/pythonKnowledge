import os
import logging
import logging.handlers

BASE_DIR = os.path.dirname(__file__)
LOG_DIR = os.path.join(BASE_DIR, "logs")
os.makedirs(LOG_DIR, exist_ok=True)

LOG_FORMAT = "%(asctime)s | %(levelname)-7s | %(name)s | %(message)s"
DATE_FORMAT = "%Y-%m-%d %H:%M:%S"

_formatter = logging.Formatter(LOG_FORMAT, datefmt=DATE_FORMAT)


def _make_file_handler(filename: str, max_bytes: int = 5 * 1024 * 1024, backup_count: int = 5):
    path = os.path.join(LOG_DIR, filename)
    h = logging.handlers.RotatingFileHandler(path, maxBytes=max_bytes, backupCount=backup_count, encoding="utf-8")
    h.setFormatter(_formatter)
    return h


def _make_console_handler():
    h = logging.StreamHandler()
    h.setFormatter(_formatter)
    return h


_app_handler = _make_file_handler("app.log")
_etl_handler = _make_file_handler("etl.log")
_enrich_handler = _make_file_handler("enrich.log")
_api_handler = _make_file_handler("api.log")
_errors_handler = _make_file_handler("errors.log")
_errors_handler.setLevel(logging.WARNING)
_console = _make_console_handler()


def get_logger(name: str) -> logging.Logger:
    """
    Returns a logger that writes to console + app.log.
    Loggers under 'etl.*' also write to etl.log.
    Loggers under 'enrich.*' also write to enrich.log.
    Loggers whose name starts with 'api' also write to api.log (HTTP timing / failures).
    All WARNING+ messages also go to errors.log.
    """
    logger = logging.getLogger(name)
    if logger.handlers:
        return logger

    logger.setLevel(logging.DEBUG)
    logger.addHandler(_console)
    logger.addHandler(_app_handler)
    logger.addHandler(_errors_handler)

    if name.startswith("etl"):
        logger.addHandler(_etl_handler)
    if name.startswith("enrich") or name.startswith("stocks"):
        logger.addHandler(_enrich_handler)
    if name.startswith("api"):
        logger.addHandler(_api_handler)

    logger.propagate = False
    return logger


def setup_root_logging():
    """Call once at startup to capture third-party warnings (yfinance, etc.)."""
    logging.captureWarnings(True)

    root = logging.getLogger()
    root.setLevel(logging.INFO)
    if not root.handlers:
        root.addHandler(_console)
        root.addHandler(_app_handler)
        root.addHandler(_errors_handler)
