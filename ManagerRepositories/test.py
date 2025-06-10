import numpy as np
import matplotlib.pyplot as plt

# Datos conocidos
P0 = 50_000_000           # Capital inicial
r = 0.005                 # Rendimiento mensual (0.5%)
n = 30                    # Meses para alcanzar la meta
FV = 115_048_014          # Monto objetivo (deuda que queremos cubrir)

# Fórmula para calcular ahorro mensual (A)
numerador = FV - P0 * (1 + r)**n
denominador = ((1 + r)**n - 1) / r
A = numerador / denominador

print(f"Ahorro mensual requerido: {A:,.0f} COP")

# Simulación mes a mes del ahorro acumulado
ahorro_acumulado = [P0]
for mes in range(1, n+1):
    saldo_anterior = ahorro_acumulado[-1]
    saldo_nuevo = saldo_anterior * (1 + r) + A
    ahorro_acumulado.append(saldo_nuevo)

# Mostrar resultados
for mes, saldo in enumerate(ahorro_acumulado):
    print(f"Mes {mes}: {saldo:,.0f} COP")

# Gráfica del ahorro acumulado mes a mes
plt.figure(figsize=(10,6))
plt.plot(range(n+1), ahorro_acumulado, marker='o')
plt.title('Simulación de ahorro acumulado mes a mes')
plt.xlabel('Mes')
plt.ylabel('Saldo acumulado (COP)')
plt.grid(True)
plt.show()
