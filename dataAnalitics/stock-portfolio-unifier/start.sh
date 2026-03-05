#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

echo "============================================"
echo "  Stock Portfolio Unifier - Starting..."
echo "============================================"
echo ""

cleanup() {
    echo ""
    echo "Shutting down..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    wait $BACKEND_PID $FRONTEND_PID 2>/dev/null
    echo "Done."
}
trap cleanup EXIT INT TERM

echo "[1/2] Starting Backend (FastAPI :8000)..."
cd backend
pip install -r requirements.txt -q 2>/dev/null
python main.py &
BACKEND_PID=$!
cd ..

sleep 2

echo "[2/2] Starting Frontend (Vue :5173)..."
cd frontend
npm install --silent 2>/dev/null
npm run dev &
FRONTEND_PID=$!
cd ..

echo ""
echo "============================================"
echo "  Both servers running:"
echo "    Backend:  http://localhost:8000"
echo "    Frontend: http://localhost:5173"
echo "    API Docs: http://localhost:8000/docs"
echo "============================================"
echo ""
echo "  First run? Visit the Dashboard and click"
echo "  \"Load/Refresh Data\" to import stock data."
echo ""
echo "  Press Ctrl+C to stop both servers."
echo ""

wait
