'''
script que muestra ejemplos de uso de algoritmo Voraz

Ejemplo 3.
Formar una cadena de string con una lista de caracteres que me indica el problema. Cada carácter leído puedo
agregarlo al inicio o al fin del String. El objetivo es formar la palabra lexicográficamente mayor posible

Ejemplo 2.
 Se debe entregar 36 pesos y se requiere gastar el menor número de monedas posibles (hay monedas de 1, 5, 10, 18 y 20).


'''
from collections import deque


def ejemplo3(palabra):
    '''
    @autor @qleoz12
    @descripcion: algoritmo voraz que ordena lexicograficamente de menor a mayor los caractes del conjunt {a,b}
    :param palabra: valor de la palabra a procesar
    :return: exponeciación de la base al exponente
    '''
    _deque = deque() #colecion para operar el ingros por izquierda o derecha
    _set= set (''.join (palabra).replace (',', '') ) #se quita duplicadad de caracteres en la palabra
    _list = list(_set) # se conviere en lista para poder operar
    if len(_list)>2: #validación de conjunto binario
        return "no operable"
    max = (ord(_list[0]) >ord(_list[1])) and ord(_list[0]) or ord(_list[1]) #comparación de cual caracter tiene mayor jerarquía en la palabra
    #print("adfsad",max)
    for letra in palabra: #iteración de cada caracter para comparar con el maximo de jerarquia en caracter
        #print(ord(letra))
        if max==ord(letra): #comparación de maximo con valor de caracter en iteracion
            _deque.appendleft(letra) #agregación a la izquierda mayor jerarqía
        else:
            _deque.append(letra) #agregación a la derecha menor jerarqía
    return ''.join(_deque) #retorno de coleccion como string


def ejemplo2(cambio):
    '''
    @autor @qleoz12
    @descripcion: algoritmo voraz que buscacambio
    :param cambio: cambio que se quiere procesar
    :return: arreglo con numero de monedas para el cambio
    '''
    #tabla de cambio donde se almacena el estado de cada una de las monedas a retornar como cambio
    tbt_cabmio = {
        20: 0,
        18: 0,
        10: 0,
        5:  0,
        1:  0
    }
    residuo=cambio
    while residuo>0: #ejecuación hasta que se alcance un valor de cero
        if residuo>20:
            residuo=divremanider(20,residuo,tbt_cabmio) # ejecución de validación de punto de corte y respectivo residuo
            continue # se rompe con el ciclo para reiniciarlo
        if residuo>18:
            residuo=divremanider(18,residuo,tbt_cabmio) # ejecución de validación de punto de corte y respectivo residuo
            continue # se rompe con el ciclo para reiniciarlo
        if residuo>10:
            residuo=divremanider(10,residuo,tbt_cabmio) # ejecución de validación de punto de corte y respectivo residuo
            continue # se rompe con el ciclo para reiniciarlo
        if residuo>5:
            residuo=divremanider(5,residuo,tbt_cabmio) # ejecución de validación de punto de corte y respectivo residuo
            continue # se rompe con el ciclo para reiniciarlo
        if residuo>=1:
            residuo=divremanider(1,residuo,tbt_cabmio) # ejecución de validación de punto de corte y respectivo residuo
            continue # se rompe con el ciclo para reiniciarlo
    #print(tbt_cabmio)
    return tbt_cabmio


def divremanider(puntodecorte,valor,diccionario):
    '''
       @autor @qleoz12
       @descripcion: funcion que reduce complejida de codigo en cada punto de corte
       :param puntodecorte: valor a comparar contra un residuo
       :param valor: valor a comparar contra el punto de corte que es sustraido en caso de ser superio al punto de corte
       :param diccionario: tabla donde se almacena el detalle de afectar o no los puntos de corte para el detalle del cambio
       :return: residuo restante de la operación
       '''
    if valor >= puntodecorte: #compara punto de corte
        diccionario[puntodecorte] += 1 #busca en el diccionario y actualiza numero de coincidencia
        valor -= puntodecorte #sustrae el valor de punto de corte

    return valor # asegura devolver un valor si entra o no por la condicion de punto de corte

if __name__ == "__main__":
    print(ejemplo3('abababbababa'))
    print(ejemplo3('azzazaza'))
    print(ejemplo3('abc'))

    print(36,ejemplo2(36))
    print(96,ejemplo2(96))
    print(69,ejemplo2(69))
    print(46,ejemplo2(46))



