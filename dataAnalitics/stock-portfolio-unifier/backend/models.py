from sqlalchemy import (
    Column, Integer, String, Float, Boolean, Date, DateTime,
    ForeignKey, UniqueConstraint, Text, Index
)
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base


class Exchange(Base):
    __tablename__ = "exchanges"
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    code = Column(String(10), nullable=False, unique=True)
    stocks = relationship("Stock", back_populates="exchange_rel")


class Stock(Base):
    __tablename__ = "stocks"
    id = Column(Integer, primary_key=True, autoincrement=True)
    ticker_yf = Column(String(20), nullable=False, unique=True)
    symbol = Column(String(20), nullable=False)
    company_name = Column(String(255), default="")
    exchange_id = Column(Integer, ForeignKey("exchanges.id"))
    sector = Column(String(100), default="")
    industry = Column(String(100), default="")
    currency = Column(String(10), default="")
    market_cap = Column(Float, default=0)
    is_quanfury_available = Column(Boolean, default=False)
    isin = Column(String(20), default="")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    exchange_rel = relationship("Exchange", back_populates="stocks")
    features = relationship("StockFeature", back_populates="stock", uselist=False, cascade="all, delete-orphan")
    dividend_events = relationship("DividendEvent", back_populates="stock", cascade="all, delete-orphan")
    dividend_forward_events = relationship(
        "DividendForwardEvent", back_populates="stock", cascade="all, delete-orphan"
    )
    manual_calendar_dividends = relationship(
        "ManualCalendarDividend", back_populates="stock", cascade="all, delete-orphan"
    )
    fair_value_revisions = relationship(
        "FairValueRevision", back_populates="stock", cascade="all, delete-orphan"
    )
    holdings = relationship("PortfolioHolding", back_populates="stock")

    __table_args__ = (
        Index("idx_stocks_exchange", "exchange_id"),
        Index("idx_stocks_sector", "sector"),
        Index("idx_stocks_quanfury", "is_quanfury_available"),
    )


class StockFeature(Base):
    __tablename__ = "stock_features"
    id = Column(Integer, primary_key=True, autoincrement=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False, unique=True)
    last_close = Column(Float)
    max_drawdown = Column(Float)
    ema_20 = Column(Float)
    ema_52 = Column(Float)
    ema_200 = Column(Float)
    macd = Column(Float)
    macd_signal = Column(Float)
    rsi_14 = Column(Float)
    dividend_ttm = Column(Float)
    payments_ttm = Column(Float)
    div_freq = Column(String(20))
    last_div_date = Column(String(20))
    div_yield_ttm = Column(Float)
    next_earnings_date = Column(String(50))
    eps_estimate = Column(Float)
    reported_eps = Column(Float)
    surprise_pct = Column(Float)
    week_52_high = Column(Float)
    week_52_low = Column(Float)
    week_100_high = Column(Float)
    week_100_low = Column(Float)
    week_200_high = Column(Float)
    week_200_low = Column(Float)

    net_income_margin = Column(Float)
    return_on_assets = Column(Float)
    free_cash_flow = Column(Float)
    operating_cash_flow = Column(Float)
    fcf_yield = Column(Float)
    revenue = Column(Float)
    net_income = Column(Float)
    total_debt = Column(Float)
    debt_to_equity = Column(Float)
    health_score = Column(Float)

    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    stock = relationship("Stock", back_populates="features")


class DividendEvent(Base):
    __tablename__ = "dividend_events"
    id = Column(Integer, primary_key=True, autoincrement=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    div_date = Column(Date, nullable=False)
    div_amount = Column(Float, nullable=False)
    stock = relationship("Stock", back_populates="dividend_events")
    __table_args__ = (
        Index("idx_div_events_stock", "stock_id"),
        Index("idx_div_events_date", "div_date"),
    )


class QuanfuryDividend(Base):
    __tablename__ = "quanfury_dividends"
    id = Column(Integer, primary_key=True, autoincrement=True)
    qf_id = Column(String(100))
    short_name = Column(String(20), nullable=False)
    amount = Column(Float, nullable=False)
    div_date = Column(Date, nullable=False)
    div_yield = Column(Float)
    currency = Column(String(10), default="USD")
    __table_args__ = (
        Index("idx_qf_div_date", "div_date"),
        Index("idx_qf_div_short_name", "short_name"),
    )


class ManualCalendarDividend(Base):
    """User-entered dividend for a specific calendar date (fills gaps vs Yahoo/CSV)."""

    __tablename__ = "manual_calendar_dividends"
    id = Column(Integer, primary_key=True, autoincrement=True)
    div_date = Column(Date, nullable=False)
    ticker_yf = Column(String(32), nullable=False)
    div_amount = Column(Float, nullable=False)
    currency = Column(String(10), default="USD")
    company_name = Column(String(255), default="")
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=True)
    note = Column(Text, default="")
    created_at = Column(DateTime, default=datetime.utcnow)
    stock = relationship("Stock", back_populates="manual_calendar_dividends")
    __table_args__ = (
        UniqueConstraint("div_date", "ticker_yf", name="uq_manual_cal_date_ticker"),
        Index("idx_manual_cal_date", "div_date"),
        Index("idx_manual_cal_ticker", "ticker_yf"),
    )


class DividendCalendarNote(Base):
    """Free-form reminder for a calendar day (e.g. review dividends on broker X)."""

    __tablename__ = "dividend_calendar_notes"
    id = Column(Integer, primary_key=True, autoincrement=True)
    note_date = Column(Date, nullable=False)
    body = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    __table_args__ = (
        Index("idx_div_cal_note_date", "note_date"),
    )


class DividendForwardEvent(Base):
    """Projected or broker-reported forward dividend dates (not replaced by CSV ETL)."""

    __tablename__ = "dividend_forward_events"
    id = Column(Integer, primary_key=True, autoincrement=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    div_date = Column(Date, nullable=False)
    div_amount = Column(Float, nullable=False)
    projection_source = Column(String(32), nullable=False)
    prior_year_div_date = Column(Date, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    stock = relationship("Stock", back_populates="dividend_forward_events")
    __table_args__ = (
        UniqueConstraint("stock_id", "div_date", name="uq_div_fwd_stock_date"),
        Index("idx_div_fwd_date", "div_date"),
        Index("idx_div_fwd_stock", "stock_id"),
    )


class Portfolio(Base):
    __tablename__ = "portfolios"
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    broker = Column(String(50), default="")
    description = Column(Text, default="")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    holdings = relationship("PortfolioHolding", back_populates="portfolio", cascade="all, delete-orphan")
    snapshots = relationship("PortfolioSnapshot", back_populates="portfolio", cascade="all, delete-orphan")


class PortfolioHolding(Base):
    __tablename__ = "portfolio_holdings"
    id = Column(Integer, primary_key=True, autoincrement=True)
    portfolio_id = Column(Integer, ForeignKey("portfolios.id"), nullable=False)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    shares = Column(Float, nullable=False, default=0)
    avg_price = Column(Float, nullable=False, default=0)
    added_at = Column(DateTime, default=datetime.utcnow)
    portfolio = relationship("Portfolio", back_populates="holdings")
    stock = relationship("Stock", back_populates="holdings")
    __table_args__ = (
        UniqueConstraint("portfolio_id", "stock_id", name="uq_portfolio_stock"),
        Index("idx_holdings_portfolio", "portfolio_id"),
    )


class FairValueRevision(Base):
    """Manual or imported fair value estimate (FVE) revisions per stock; effective_date starts the step."""
    __tablename__ = "fair_value_revisions"
    id = Column(Integer, primary_key=True, autoincrement=True)
    stock_id = Column(Integer, ForeignKey("stocks.id", ondelete="CASCADE"), nullable=False)
    effective_date = Column(Date, nullable=False)
    fair_value = Column(Float, nullable=False)
    uncertainty = Column(String(50), nullable=True)
    source = Column(String(50), nullable=False, default="manual")
    created_at = Column(DateTime, default=datetime.utcnow)

    stock = relationship("Stock", back_populates="fair_value_revisions")
    __table_args__ = (
        UniqueConstraint("stock_id", "effective_date", "source", name="uq_fve_stock_effective_source"),
        Index("idx_fve_stock_effective", "stock_id", "effective_date"),
    )


class StockOHLCV(Base):
    __tablename__ = "stock_ohlcv"
    id = Column(Integer, primary_key=True, autoincrement=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    date = Column(Date, nullable=False)
    open = Column(Float)
    high = Column(Float)
    low = Column(Float)
    close = Column(Float)
    volume = Column(Float)
    __table_args__ = (
        UniqueConstraint("stock_id", "date", name="uq_ohlcv_stock_date"),
        Index("idx_ohlcv_stock_date", "stock_id", "date"),
    )


class ChartDrawing(Base):
    __tablename__ = "chart_drawings"
    id = Column(Integer, primary_key=True, autoincrement=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    drawing_type = Column(String(20), nullable=False)
    price1 = Column(Float, nullable=False)
    price2 = Column(Float)
    date1 = Column(String(20))
    date2 = Column(String(20))
    color = Column(String(20), default="#facc15")
    label = Column(String(100), default="")
    created_at = Column(DateTime, default=datetime.utcnow)
    __table_args__ = (
        Index("idx_drawings_stock", "stock_id"),
    )


class PortfolioSnapshot(Base):
    __tablename__ = "portfolio_snapshots"
    id = Column(Integer, primary_key=True, autoincrement=True)
    portfolio_id = Column(Integer, ForeignKey("portfolios.id"), nullable=False)
    month = Column(Integer, nullable=False)
    year = Column(Integer, nullable=False)
    total_value = Column(Float, default=0)
    total_dividends = Column(Float, default=0)
    notes = Column(Text, default="")
    created_at = Column(DateTime, default=datetime.utcnow)
    portfolio = relationship("Portfolio", back_populates="snapshots")
    __table_args__ = (
        UniqueConstraint("portfolio_id", "month", "year", name="uq_snapshot_period"),
        Index("idx_snapshots_portfolio", "portfolio_id"),
    )


class ArbitrageSnapshot(Base):
    """Cached arbitrage rates fetched from external APIs."""
    __tablename__ = "arbitrage_snapshots"
    id = Column(Integer, primary_key=True, autoincrement=True)
    source = Column(String(50), nullable=False)
    pair = Column(String(20), nullable=False)
    bid = Column(Float)
    ask = Column(Float)
    mid = Column(Float)
    volume_24h = Column(Float)
    raw_json = Column(Text, default="")
    fetched_at = Column(DateTime, default=datetime.utcnow)
    __table_args__ = (
        Index("idx_arb_source_pair", "source", "pair"),
        Index("idx_arb_fetched_at", "fetched_at"),
    )


class ArbitrageOperation(Base):
    """Manual trade log for arbitrage cycles."""
    __tablename__ = "arbitrage_operations"
    id = Column(Integer, primary_key=True, autoincrement=True)
    pair = Column(String(20), nullable=False)
    buy_source = Column(String(50), nullable=False)
    sell_source = Column(String(50), nullable=False)
    buy_price = Column(Float, nullable=False)
    sell_price = Column(Float, nullable=False)
    amount_usdt = Column(Float, nullable=False)
    fee_total = Column(Float, default=0)
    net_profit = Column(Float, default=0)
    net_profit_pct = Column(Float, default=0)
    status = Column(String(20), default="open")
    notes = Column(Text, default="")
    created_at = Column(DateTime, default=datetime.utcnow)
    __table_args__ = (
        Index("idx_arb_op_pair", "pair"),
        Index("idx_arb_op_status", "status"),
    )
