import os
import pathlib
import time

# ------------------------------------- Cliente -----------------------------------#
from random import randint

import pandas as pd
from scipy.stats.distributions import chi2
"""
varianza en números pseudoaleatorios

La prueba de varianza consiste en determinar la varianza de los n números que
contiene el conjunto ri, mediante la ecuación siguiente:
Determine la varianza utilizando la expresión matemática anterior.
2. Calcular los límites de aceptación inferior y superior con las ecuaciones siguientes:
Determine si la varianza obtenida está entre los límites de aceptación.
3. Si el valor de V(r) se encuentra entre los límites de aceptación, decimos que no se
puede rechazar que el conjunto ri tiene una varianza de 1/12, con un nivel de
aceptación de 1 - α; de lo contrario, se rechaza que el conjunto tiene una varianza
de 1/12. Para obtener valores de los factores Chi-cuadrada vea los anexos del libro.
4. Se deben tomar los 99 números aleatorios generados por ustedes en el laboratorio_I
del Generador Lineal Congruencial, posteriormente realizar todos los
procedimientos de los puntos 1 al 3, debe indicar si su generador de números
aleatorios es bueno o no según la prueba de varianza, es decir si la hipótesis es
probada o no.
"""

def varianza(df):

    alfa=0.05
    print(round(df[0].mean(),4)) #impresion mediana automarica
    df['value-mean']=df[0]-df[0].mean() # valor menos la media de todos los valores
    df['value-mean^2'] = df['value-mean']**2
    print (df)
    varianzaManual=round(df["value-mean^2"].sum()/(df[0].count()-1),8)
    print("1. la varianza obtenida es "+ varianzaManual.__str__())
    print(df[0].var()) #varianza autoimatica de pandas
    denominador=(12*(df[0].count()-1))  #12(n-1)
    print(denominador)
    limiteInferior=chi2.ppf(alfa/2, df=39) /denominador
    limiteSuperior = chi2.ppf((1-(alfa/2)), df=39)/denominador
    print("2. el limite inferior es "+limiteInferior.__str__())
    print("2. el limite superior es "+limiteSuperior.__str__())
    LimiteAceptable =  limiteInferior <= varianzaManual <= limiteSuperior
    print("3. la varianza obtenida está entre los límites de aceptación : {}".format(LimiteAceptable))




if __name__ == '__main__':
    datosBook = [0.0449, 0.6015, 0.63, 0.5514, 0.0207,
             0.1733, 0.6694, 0.2531, 0.0316, 0.1067,
             0.5746, 0.3972, 0.8297, 0.3587, 0.3857,
             0.049, 0.7025, 0.6483, 0.7041, 0.1746,
             0.8406, 0.1055, 0.6972, 0.5915, 0.3362,
             0.8349, 0.1247, 0.9582, 0.2523, 0.1589,
             0.92, 0.1977, 0.9085, 0.2545, 0.3727,
             0.2564, 0.0125, 0.8524, 0.3044, 0.4145]

    datos = [0.0449, 0.6015, 0.63, 0.5514, 0.0207,
             0.1733, 0.6694, 0.2531, 0.3116, 0.1067,
             0.5746, 0.3972, 0.8297, 0.3587, 0.3887,
             0.049, 0.7025, 0.6483, 0.7041, 0.1746,
             0.8406, 0.1055, 0.6972, 0.5915, 0.3362,
             0.8349, 0.1247, 0.9582, 0.2523, 0.1589,
             0.92, 0.1977, 0.9085, 0.2545, 0.3727,
             0.2564, 0.0125, 0.8524, 0.3044, 0.4145]

    df = pd.DataFrame(datos) # se crea dataframe de la serie de datos
    varianza(df)
    # -----------------------------------------------------------------------------------------------------
    path = os.path.dirname(os.path.abspath(__file__)) + "\\generadorlinealcongruencial\\lgc_output.txt"
    df = pd.read_csv(path, sep=" ", header=None)
    print(df.to_string())
    varianza(df)

    print("4. debe indicar si su generador de números aleatorios es bueno o no según la prueba de varianza, es decir si la hipótesis es probada o no. ")

    print("el generador es bueno si se cumplen las reglas, pero este caso no lo es ya que las iteraciones son 99  "
          "en un rango de 100 numeros, por lo que lo recomendable sería aumentar el rango M de LGC para tener un valor"
          " superior para que permita mayor disperción")
    print("la hipotesis se compureba")