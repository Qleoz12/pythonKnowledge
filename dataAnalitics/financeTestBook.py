import pandas as pd
import yfinance as yf
import numpy as np
from scipy.optimize import minimize
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib import cycler
import warnings

# Ignorar warnings para una salida más limpia
warnings.filterwarnings("ignore")

# Configuración de Matplotlib
plt.style.use('seaborn-v0_8') # Usar 'seaborn-v0_8' o 'seaborn' dependiendo de tu versión de Matplotlib
font = {'weight' : 'bold', "size": 12} # Ajusté el tamaño de fuente para evitar errores
plt.rc('font', **font)

# --- 1. Tus Acciones ---
# Lista de tickers de tu portafolio
list_tickers = ["AGNC", "RYN", "STWD", "MAN", "DOW", "E", "MAIN", "NNN", "ASR", "VZ", "BTI", "JEPQ", "FSK"]

# --- 2. Asignación de Pesos (EQUIPONDERADOS para empezar) ---
# Como no me has dado tus pesos exactos, asignaremos un peso igual a cada acción.
# Puedes cambiar esto si conoces tus porcentajes reales.
n_assets = len(list_tickers)
weights = np.ones(n_assets) / n_assets

print(f"Número de activos en tu portafolio: {n_assets}")
print(f"Pesos iniciales (equitativos): {np.round(weights, 4)}")
print("-" * 70)

# --- 3. Descarga y Preparación de Datos ---
print("Descargando datos históricos...")
# Descargar datos desde una fecha de inicio (ej. 5 años atrás) hasta hoy
# Puedes ajustar las fechas según tus necesidades.
start_date = "2018-01-01"
end_date = pd.to_datetime('today').strftime('%Y-%m-%d') # Fecha actual
database = yf.download(list_tickers, start=start_date, end=end_date)

# Seleccionar solo los precios ajustados de cierre, calcular retornos diarios y eliminar valores nulos
data = database["Adj Close"].dropna().pct_change(1).dropna()
print(f"Datos históricos descargados para {len(data)} días de trading.")
print("-" * 70)

# --- 4. Definición de la Función de Backtest (tal como la proporcionaste) ---

def backtest_static_portfolio(weights, database, ben="^GSPC", timeframe=252, CR=False):
    """
    -----------------------------------------------------------------------------
    | Output: Beta CAPM metric                                                  |
    -----------------------------------------------------------------------------
    | Inputs: - weights (type 1d array numpy): weights of the portfolio       |
    |         - database (type dataframe pandas): Returns of the asset        |
    |         - ben (type string): Name of the benchmark                      |
    |         - timeframe (type int): annualization factor                    |
    -----------------------------------------------------------------------------
    """
    # Compute the portfolio
    portfolio = np.multiply(database, np.transpose(weights))
    portfolio = portfolio.sum(axis=1)
    columns = database.columns
    columns = [col for col in columns]

    ######################### COMPUTE THE BETA ##################################
    # Importation of benchmark
    benchmark = yf.download(ben)["Adj Close"].pct_change(1).dropna()

    # Concat the asset and the benchmark
    join = pd.concat((portfolio, benchmark), axis=1).dropna()

    # Rename columns for clarity in printing
    join.columns = ['Portfolio', 'Benchmark']

    # Covariance between the asset and the benchmark
    cov = np.cov(join, rowvar=False)[0][1]

    # Compute the variance of the benchmark
    var = np.cov(join, rowvar=False)[1][1]

    beta = cov/var


    ######################### COMPUTE THE ALPHA #################################
    # Mean of returns for the asset
    mean_stock_return = join.iloc[:,0].mean()*timeframe

    # Mean of returns for the market
    mean_market_return = join.iloc[:,1].mean()*timeframe

    # Alpha
    alpha = mean_stock_return - beta*mean_market_return


    ######################### COMPUTE THE SHARPE ################################
    mean = portfolio.mean() * timeframe
    std = portfolio.std() * np.sqrt(timeframe)
    Sharpe = mean/std


    ######################### COMPUTE THE SORTINO ###############################
    downward = portfolio[portfolio<0]
    std_downward = downward.std() * np.sqrt(timeframe)
    Sortino = mean/std_downward


    ######################### COMPUTE THE DRAWDOWN ###############################
    # Compute the cumulative product returns
    cum_rets = (portfolio+1).cumprod()

    # Compute the running max
    running_max = np.maximum.accumulate(cum_rets.dropna())
    running_max[running_max < 1] = 1

    # Compute the drawdown
    drawdown = ((cum_rets)/running_max - 1)
    min_drawdon = -drawdown.min()


    ######################### COMPUTE THE VaR ##################################
    theta = 0.01
    # Number of simulations
    n = 100000

    # Find the values for theta% error threshold
    t = int(n*theta)

    # Create a vector with n simulations of the normal law
    vec = pd.DataFrame(np.random.normal(mean, std, size=(n,)),
    columns = ["Simulations"])

    # Orderer the values and find the theta% value
    VaR = -vec.sort_values(by="Simulations").iloc[t].values[0]


    ######################### COMPUTE THE cVaR #################################
    cVaR = -vec.sort_values(by="Simulations").iloc[0:t,:].mean().values[0]

    ######################### COMPUTE THE RC ###################################
    if CR:
        # Find the number of the asset in the portfolio
        l = len(weights)

        # Compute the risk contribution of each asset
        crs = []
        for i in range(l):
            # Importation of benchmark - THIS IS REDUNDANT HERE, BENCHMARK ALREADY DOWNLOADED ONCE
            # For efficiency, we should pass the benchmark data as an argument or download it once outside the loop
            # For now, keeping as is from your provided code to match
            local_benchmark = yf.download(ben, start=database.index.min(), end=database.index.max())["Adj Close"].pct_change(1).dropna()


            # Concat the asset and the benchmark
            join_single_asset = pd.concat((database.iloc[:,i], local_benchmark), axis=1).dropna()


            # Covariance between the asset and the benchmark
            cov_s = np.cov(join_single_asset, rowvar=False)[0][1]

            # Compute the variance of the benchmark
            var_s = np.cov(join_single_asset, rowvar=False)[1][1]
            beta_s = cov_s/var_s
            cr = beta_s * weights[i]
            crs.append(cr)
        crs_ = np.array(crs)/np.sum(crs) # Normalizing by the sum of the risk contribution

    ######################### PLOT THE RESULTS #################################
    print(f"""
    -----------------------------------------------------------------------------
    Portfolio: {columns}
    -----------------------------------------------------------------------------
    Beta: {np.round(beta, 3)} \t Alpha: {np.round(alpha*100, 2)} %\t \
    Sharpe: {np.round(Sharpe, 3)} \t Sortino: {np.round(Sortino, 3)}
    -----------------------------------------------------------------------------
    VaR: {np.round(VaR*100, 2)} %\t cVaR: {np.round(cVaR*100, 2)} % \t \
    VaR/cVaR: {np.round(cVaR/VaR, 3)} \t drawdown: {np.round(min_drawdon*100, 2)} %
    -----------------------------------------------------------------------------
    """)

    plt.figure(figsize=(15,8))
    plt.plot(join.index, join['Portfolio'].cumsum()*100, color="#035593", linewidth=3)
    plt.plot(join.index, join['Benchmark'].cumsum()*100, color="#068C72", linewidth=3)
    plt.title("RETORNO ACUMULADO", size=15)
    plt.ylabel("Retorno Acumulado %", size=15)
    plt.xticks(size=12, fontweight="bold")
    plt.yticks(size=12, fontweight="bold")
    plt.legend(["Estrategia", "Benchmark"])
    plt.grid(True)
    plt.show()

    plt.figure(figsize=(15,8))
    plt.fill_between(drawdown.index, drawdown*100, 0, color="#CE5151", alpha=0.7)
    plt.plot(drawdown.index, drawdown*100, color="#930303", linewidth=1.5)
    plt.title("DRAWDOWN", size=15)
    plt.ylabel("Drawdown %", size=15)
    plt.xticks(size=12, fontweight="bold")
    plt.yticks(size=12, fontweight="bold")
    plt.grid(True)
    plt.show()


    if CR:
        plt.figure(figsize=(15,8))
        plt.scatter(columns, crs_, linewidth=3, color = "#B96553")
        plt.axhline(0, color="#53A7B9")
        plt.grid(axis="x")
        plt.title("CONTRIBUCIÓN AL RIESGO DEL PORTAFOLIO", size=15)
        plt.xlabel("Activos")
        plt.ylabel("Contribución al Riesgo")
        plt.xticks(rotation=45, ha='right', size=12, fontweight="bold") # Rotar etiquetas para mejor legibilidad
        plt.yticks(size=12, fontweight="bold")
        plt.grid(True)
        plt.tight_layout() # Ajustar el diseño para que las etiquetas no se corten
        plt.show()

# --- 5. Ejecutar el Backtest para tu Portafolio ---
print("Ejecutando backtest para tu portafolio...")
backtest_static_portfolio(weights, data, CR=True)