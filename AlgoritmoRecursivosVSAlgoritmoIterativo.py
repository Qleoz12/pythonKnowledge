'''
script que muestra las diferencias entre las lógicas de algoritmos recursivos y los algoritmos iterativos

'''

def exponenciacionRecursivo(base, exponente):
    '''
    @autor @qleoz12
    @descripcion: algoritmo recursivo simple de exponenciación
    :param base: valor de la base que se envía
    :param exponente: cantidad de veces que se multiplica
    :return: exponeciación de la base al exponente
    '''
    if exponente == 1:
        return base
    else:
        return base * exponenciacionRecursivo(base, exponente - 1)


def exponenciacionRecursivo2(base, exponente):
    '''
    @autor @qleoz12
    @descripcion: algoritmo recursivo multiple de exponenciación
    :param base: valor de la base que se envía
    :param exponente: cantidad de veces que se multiplica
    :return: exponeciación de la base al exponente
    '''
    """ Precondición: n debe ser mayor o igual que cero.
        Devuelve: b\^n. """
    #print(base,exponente)
    # Caso base
    if exponente <= 0:
        return 1

    # n par
    if exponente % 2 == 0:
        pot = exponenciacionRecursivo2(base, exponente / 2)
        return pot * pot
    # n impar
    else:
        pot = exponenciacionRecursivo2(base, (exponente - 1) / 2)

        return pot * pot * base




def exponenciacionIterativo(base, exponente):
    '''
    @autor @qleoz12
    @descripcion: algoritmo recursivo de exponenciación
    :param base: valor de la base que se envía
    :param exponente: cantidad de veces que se multiplica
    :return: exponeciación de la base al exponente
    '''
    exponecial = base
    # print(exponecial)
    for x in range(1, exponente):
        exponecial = exponecial * base

    # print(exponecial)
    return exponecial


if __name__ == "__main__":
    print(exponenciacionIterativo(2, 5))
    print(exponenciacionRecursivo(2, 5))

    print(exponenciacionIterativo(3, 3))
    print(exponenciacionRecursivo(3, 3))

    print(exponenciacionIterativo(8, 6))
    print(exponenciacionRecursivo(8, 6))

    print(exponenciacionIterativo(65, 15))
    print(exponenciacionRecursivo(65, 15))

    print(exponenciacionRecursivo2(65, 15))
    print(exponenciacionRecursivo2(65, 15))

