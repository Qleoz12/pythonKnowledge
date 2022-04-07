import time

# ------------------------------------- Cliente -----------------------------------#
from random import randint


def Cliente():
    #
    pass


def getHoraCliente(desface=0):
    # horaServidor = horaServer.split(' ') # guardo la hora del servidor en una lista
    horaUTC = time.localtime()  # se define horaUTC obteniendo la hora local
    minutos = int(horaUTC[3]) * 60 + int(horaUTC[4]) + desface  # se cambia la hora a minutos con desface
    # print "minutos : "+ str(minutos)
    horaTotal = [int(minutos / 60), minutos % 60]  # se cambian los minutos a horas
    # print "hora Cliente 1 -> " + str(horaTotal)
    return horaTotal  # se retorna la diferencia y la hora total


# ------------------------------------- Servidor ----------------------------------#

# Obtiene la hora del servidor
def getHoraServer():
    horaUTC = time.localtime()  # se define horaUTC obteniendo el tiempo local
    horaServer = [horaUTC[3], horaUTC[4]]  # se define la hora del server
    # print "Hora Server ->" +str(horaServer)
    return horaServer  # se retorna la diferencia y la hora total


def calcularDiferencias(horaCliente, horaServer):
    minutosCliente = int(horaCliente[0]) * 60 + int(horaCliente[1])  # se cambian las horas del cliente a minutos
    # print "minutos Cliente : "+ str(minutosCliente)

    minutosServer = int(horaServer[0]) * 60 + int(horaServer[1])  # se cambian las horas del server a minutos
    # print "minutos Servidor : "+ str(minutosServer)

    # para este caso no se contempla tiempos de carga en los casoso reales la diferencia contempla la resta de
    # el promedio de tiempo de ida y vuelta
    latencia = 0

    diferencia = minutosCliente - minutosServer - (latencia / 2)  # se hace la diferencia de los minutos
    # print "diferencia : "+ str(diferencia)

    return str(diferencia)


# metodo que convierte las hotas en misnutos para podder sacar una diferencia entre 2 horas.
def calcularHoras(diferencias, *horas):
    # horas = horas.split(' ')
    print("horas: " + str(horas))

    minutos = []
    i = 0
    # print (horas[i][0])
    for hora in horas:  # iteramos cada hora
        minutos.append(int(hora[0]) * 60 + int(hora[1]))
        #print(minutos)
        i += 1

    print("minutos: " + str(minutos))

    # calculando promedios--------------------------------
    cantidadDiferencias = len(diferencias)
    suma = 0 #acumulable de suma para promedio de la suma
    for diferencia in diferencias:
        suma = suma + int(float(diferencia)) # se acumula cada suma de diferencia

    promedio = suma / cantidadDiferencias #se calcula el promedio
    print("promedio : " + str(promedio))

    # calculando nuevas diferencias ----------------------
    nuevasDiferencias = []
    for diferencia in diferencias:
        nuevasDiferencias.append(promedio - int(float(diferencia))) # se guardan nuevas diferencias apartir del promedio calculado
    print("nuevas Diferencias: " + str(nuevasDiferencias))

    # calculando nuevas horas ----------------------------
    pos = 0
    nuevasHoras = []
    for nuevaDiferencia in nuevasDiferencias:
        print(minutos[pos], round(float(nuevaDiferencia)), nuevaDiferencia) #impresion de tiempo , diferencia con promedio con redondeo ,diferencia con promedio
        nuevasHoras.append(minutos[pos] + round(float(nuevaDiferencia))) # se calculan las nuevas horas con la suma de la hora inicial con la diferencia promediada calculada
        pos += 1

    print("nuevas Horas: " + str(nuevasHoras))
    return nuevasHoras

###
# logica de algoritmo de berkeley
###
def obtenerHoraCliente():
    horas = []
    diferencias = []  # cadena de diferencias

    horaServer = getHoraServer()  # obtiene la hora del Servidor
    print("hora servidor : " + str(horaServer))
    diferenciaServer = calcularDiferencias(horaServer, horaServer) # se agrega al calculo la hora del servidor
    diferencias.append(diferenciaServer) # se guarda la diferencia
    horas.append(str(horaServer))       # se guarda la hora

    #emular clientes con diferentes horas
    for x in range(3):
        horaCliente = getHoraCliente(randint(0, 60)) #se crea un cliente con desface aleatorio
        print("hora cliente {}: ".format(x + 1) + str(horaCliente))
        diferenciaCliente1 = calcularDiferencias(horaCliente,
                                                 horaServer)  # calcula diferencia del cliente con respecto al servidor
        diferencias.append(diferenciaCliente1)
        horas.append(str(horaCliente))

    # Grenerando cadena de Horas ---------------------------
    strHoras = ' '.join(horas)  #
    bracketLeft = strHoras.replace("[", "")
    bracketRight = bracketLeft.replace("]", "")
    commas = bracketRight.replace(",", "")

    print(commas)
    hrs = commas.split(" ")
    print(hrs)

    i = 0
    horas = []
    #creacion de conjunto de hora para calculo de la diferencia entre las horas del servidor y los clientes
    while i < len(hrs):
        hourAux = []
        hourAux.append(hrs[i])
        hourAux.append(hrs[i + 1])
        horas.append(hourAux)
        i += 2
    # ------------------------------------------------------

    print("diferencias: " + str(diferencias))

    nuevasHoras = calcularHoras(diferencias, *horas) #metodo de ajuste de las horas
    print(nuevasHoras)


if __name__ == '__main__':
    obtenerHoraCliente()
