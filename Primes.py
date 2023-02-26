import math

import numpy as np


"""
Sucede que los factores de un número se presentan en pares.

Si a es un factor del número n, entonces también existe un factor b tal que a x b = n, o simplemente, ab = n.

Verifiquemos esto a través de un ejemplo.

La siguiente tabla muestra los factores del número 18 que ocurren en pares. Puede verificar lo mismo para algunos números más si lo desea.

Además, tenga en cuenta que √18 es aproximadamente 4,24.

Y en los factores que ocurren en pares (a, b), puedes ver que si a es menor que 4.24, entonces b es mayor que 4.24—en este ejemplo, 
(1, 18)= 18
(2, 9)= 18
(3, 6)= 18.


las series de numeros se puede descomponer en factores
https://geekflare.com/prime-number-in-python/
"""
def is_prime(n):
  for i in range(2,int(math.sqrt(n))+1):
    if (n%i) == 0:
      return False
  return True


if __name__ == '__main__':
    x = int(input("Enter a number: "))
    for i in np.arange(x):
        if is_prime(i):
            print(i)


arreglo=[1,2,3,4]
