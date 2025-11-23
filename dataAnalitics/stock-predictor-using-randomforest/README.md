# Next Day Stock Price Prediction of the S&P 500 using Random Forest

## Overview
This project uses a Random Forest Classifier to predict the daily price movements of the S&P 500 index, using the SPY - [SPDR S&P 500 ETF Trust] as a proxy for total S&P 500 market conditions. The model analyzes historical price data and various derived features to make predictions on whether the stock price will go up or down on the next trading day.

## What is the the SPDR S&P 500 ETF?
The SPDR S&P 500 ETF Trust is among the most popular exchange-traded funds (ETFs). It aims to track the Standard & Poor’s (S&P) 500 Index, which comprises 500 large-cap U.S. stocks. These stocks are selected by a committee based on market size, liquidity, and industry. The S&P 500 serves as one of the main benchmarks of the U.S. equity market and indicates the financial health and stability of the economy. Also known as the SPY ETF, it was established in January 1993.

## Features
- Acquisition of the entire trade history of SPY using yfinance library
- Feature engineering including moving averages, price ratios, and trends
- Random Forest Classifier for prediction
- Custom backtesting function for model evaluation
- Visualization of predictions and actual stock movements

## Requirements
- Python 3.11.5
- yfinance
- pandas
- numpy
- scikit-learn
- matplotlib

## Installation
1. Clone this repository: git clone https://github.com/m-turnergane/stock-predictor-using-randomforest.git

2. Navigate to the project directory: cd stock_predictor_RandomForest

3. Install the required packages: pip install -r requirements.txt

## Usage
1. Open the Jupyter notebook:

2. Run the cells in the notebook to:
- Download historical data for SPY
- Prepare and engineer features
- Train the Random Forest model
- Backtest the model
- Visualize results

## Model Performance
The current model achieves a precision score of approximately 0.67. This means that when the model predicts an upward movement, it is correct about 67% of the time.

## Future Improvements
- Implement additional technical indicators (e.g., MACD, RSI, and/or, SMA along with others)
- Explore feature selection techniques
- Implement cross-validation for more robust evaluation
- Experiment with hyperparameter tuning
- Potentially experiment with other models (Logistic Regression for binary classification such as this project's task, or LSTM if making a more complex prediction model interests you)

## Disclaimer
This project is for educational purposes only. The predictions made by this model should not be used as financial advice. Always consult with youre financial advisor before making investment decisions.

## Contact
Muhammad Gane - m.turnergane@gmail.com

Project Link: https://github.com/m-turnergane/stock-predictor-using-randomforest
"# stock-predictor-using-randomforest" 
"# stock-predictor-using-randomforest" 
"# stock-predictor-using-randomforest" 
