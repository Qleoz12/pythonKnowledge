"""
Esta función toma tres valores numéricos y devuelve su suma.

Parámetros:
- a, b, c: Valores numéricos a sumar.

Retorna:
- La suma de los tres valores.
"""

def sumar_tres_valores(a, b, c):
    suma = a + b + c
    return suma

def obtener_valor_valido():
    while True:
        try:
            valor = int(input("Ingresa un número mayor a 0: "))
            if valor > 0:
                return valor
            else:
                print("Por favor, ingresa un número mayor a 0.")
        except ValueError:
            print("Por favor, ingresa un número valido.")

# Ejemplo de uso:
valor_a = obtener_valor_valido()
valor_b = obtener_valor_valido()
valor_c = obtener_valor_valido()

resultado = sumar_tres_valores(valor_a, valor_b, valor_c)
print("La suma de los tres valores es:", resultado)
