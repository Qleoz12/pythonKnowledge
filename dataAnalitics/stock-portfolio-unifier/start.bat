@echo off
title Stock Portfolio Unifier
echo ============================================
echo   Stock Portfolio Unifier - Starting...
echo ============================================
echo.

cd /d "%~dp0"

echo [1/2] Starting Backend (FastAPI :8000)...
start "Backend - FastAPI" cmd /k "cd backend && pip install -r requirements.txt -q && python main.py"

echo [2/2] Starting Frontend (Vue :5173)...
timeout /t 3 /nobreak >nul
start "Frontend - Vue" cmd /k "cd frontend && npm install --silent && npm run dev"

echo.
echo ============================================
echo   Both servers starting in new windows:
echo     Backend:  http://localhost:8000
echo     Frontend: http://localhost:5173
echo     API Docs: http://localhost:8000/docs
echo ============================================
echo.
echo   First run? Visit the Dashboard and click
echo   "Load/Refresh Data" to import stock data.
echo.
echo   Press any key to open the app in browser...
pause >nul
start http://localhost:5173
