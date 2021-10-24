'''
script que muestra ejemplos de uso de algoritmo Voraz

Consideramos el problema de la mochila modificado, consistente en dado un tablero de dimensiones M1 x M2 y n piezas de dimensiones i1 x j1, i2 x j2, ..., in x jn, cada una de ellas con beneficio b1, b2, ..., bn respectivamente, maximizar el beneficio de poner las piezas en el tablero teniendo en cuenta que las piezas se pueden separar en cuadrículas para ponerlas en el tablero.
Resolver el problema implementando un algoritmo voraz en lenguaje JAVA, teniendo en cuenta lo siguiente:
Entradas del programa:
• Tamaño del tablero (largo x ancho) • # de figuras, indicando de cada una su largo, ancho y alto
Salidas del programa:
• Figuras que se utilizan para optimizar el problema • Máximo beneficio posible


'''
from collections import deque


def calculoMejorBeneficio():
    '''
       @autor @qleoz12
       @descripcion: funcion que reduce complejida de codigo en cada punto de corte
       :param puntodecorte: valor a comparar contra un residuo
       :param valor: valor a comparar contra el punto de corte que es sustraido en caso de ser superio al punto de corte
       :param diccionario: tabla donde se almacena el detalle de afectar o no los puntos de corte para el detalle del cambio
       :return: residuo restante de la operación
    '''
    largoEdificio = input()
    anchoEdificio= input()

    area=largoEdificio*anchoEdificio
    print()


if __name__ == "__main__":
    print(ejemplo3('abababbababa'))
    print(ejemplo3('azzazaza'))
    print(ejemplo3('rssrsrsrsrs'))
    print(ejemplo3('abc'))
    print(ejemplo3('Electrocardiograma'))
    print(ejemplo3('juanvera'))

    print('===========================================')

    print(36,ejemplo2(36))
    print(98, ejemplo2(98))
    print(96,ejemplo2(96))
    print(69,ejemplo2(69))
    print(46,ejemplo2(46))



