import uuid
from random import randrange

import numpy as np

from generador_lineal_congruencial import LGC_generator
import matplotlib.pyplot as plt


def calcularVuelo(pais_origen,pais_destino,precio_directo,tiempo_estimado_total,escalas,cantidad):
    """
    pais_origen= parametro de pais de orgen
    pais_destino= parametro de pais de destino
    precio_directo=precio del vuelo directo
    tiempo_estimado_total=tiempo estimado si fuera directo
    escalas=numero de escaladas
    cantidad= cantidad de pasajeros

    """
    print(cantidad, tiempo_estimado_total)
    costonicial=precio_directo/cantidad  # se divide el precio del vuelo directo sobre la cantidad de escaladas
    cantidad_total=cantidad  #cantidad total de escaladas
    cantidad_actual = cantidad
    tiempo_escala=0
    valor_total_vuelo=0
    valor_escalada = 0
    valor_beneficio=0
    Matrix = [[0 for x in range(3)] for y in range(escalas)] # se crea una matriz
    viaje=[]
    if escalas>0:
        # calculo para cada iteracion
        for x in range(escalas):
            print("escala : "+str(x+1))
            print("escala info: " + str(escalas-x))
            print(cantidad_total, cantidad_actual, tiempo_estimado_total, tiempo_escala)
            valor_por_hora = precio_directo / (tiempo_estimado_total/(escalas-x))  # se divide el valor del vuelo diorecto sobre tiempo de las escaladas restantes menos el tiempo total directo
            valor_por_persona = precio_directo / cantidad_actual # precio dividivo por la cantida de personas en el vuelo
            valor_escalada=(valor_por_hora+valor_por_persona)/2 # valor por hora + valor_por_persona
            valor_total_vuelo+=valor_escalada                  # acumulador del valor del vuelo para almacenar valor de la escalada
            valor_beneficio+=(valor_escalada-(costonicial/escalas)) # acumulador de valor de beneficio  donde es el valor de escalada menos (el costo inicial sobre las escaladas)
            Matrix[x][0]=(valor_escalada-(costonicial/escalas))    # matriz para grafica valor de beneficio
            Matrix[x][1]=valor_escalada                            # matriz valor escalada
            Matrix[x][2] = costonicial                             # costo inicial
            print("precio hasta escalada "+str(valor_escalada))
            print("beneficio " + str((valor_escalada-(costonicial/escalas))))
            pasajeros_suben, pasajeros_bajan, cantidad_actual, tiempo_escala = calcular_escala(tiempo_estimado_total, cantidad_total,cantidad_actual)
            print("tiempo trayecto  " +str(tiempo_estimado_total/(escalas-x)))
            print("tiempo escala  " + str(tiempo_escala))
            print(tiempo_estimado_total)
            # tiempo_estimado_total-=(tiempo_estimado_total/(tiempo_estimado_total/(escalas-x))) #resto de trayecto consumido
            print(tiempo_estimado_total)
            tiempo_estimado_total+=tiempo_escala #sumo tiempo de escala

            viaje.append(
                {
                    "escala": str(x + 1),
                    "precio hasta escalada ": str(valor_escalada),
                    "beneficio " : str((valor_escalada - (costonicial / escalas))),
                    "tiempo trayecto  " : str(tiempo_estimado_total / (escalas - x)),
                    "tiempo escala  ": str(tiempo_escala),
                    "pasajeros_suben": str(pasajeros_suben),
                    "pasajeros_bajan": str(pasajeros_bajan),

                }
            )
            print("---------------------------------------------------------------------------------------------------")

    print("valor final de vuelo "+str(valor_total_vuelo))
    print(Matrix)

    data = np.array(Matrix)                      # matriz a array
    x = np.arange(data.shape[0])
    dx = (np.arange(data.shape[1]) - data.shape[1] / 2.) / (data.shape[1] + 2.)
    d = 1. / (data.shape[1] + 2.)                 # calculo del tamaño de las barras en grafico
    print(data)
    fig, ax = plt.subplots()                      #objetos de  graficas
    labels = ['beneficio', 'cobro escalada ','costo'] # label para la matriz [n X 3]
    for i in range(data.shape[1]):
        ax.bar(x + dx[i], data[:, i], width=d, label=labels[i])  #carga de barras

    fig.set_size_inches(18.5, 10.5) #tamaño de grafico en pulgadas
    name="assets/images/flight_"+str(uuid.uuid4())+".png"   #nombramiento de imagen de grafico con uuid para actualizar la pagina
    plt.legend(framealpha=1)
    plt.savefig(name, dpi=300)        # guardado de imagen
    plt.close()       # cierre

    return viaje,fig,name     # retorno de array del viaje para la tabla html,de la figura o imagen generada  y del name que es la ruta de la imagen




def calcular_escala(tiempo_restante,cantidad_total,cantidad_actual):
    """
    tiempo_restante=tiempo restante si fuera directo
    cantidad_total= cantidad maxima para subida o bajada
    cantidad_actual = cantidad actual en avion
    """
    tiempo_escala=0
    tiempo_usado=0

    pasajeros_bajan_escala=LGC_generator().getRamdon_glc(cantidad_actual) #ramdonn menor a la cantidad actual
    print("pasajeros que bajan: "+ str(pasajeros_bajan_escala))
    cantidad_actual=cantidad_actual-pasajeros_bajan_escala
    pasajeros_suben_escala =LGC_generator().getRamdon_glc(cantidad_total-cantidad_actual)  #ramdom de valor de limite menor los pasajeros actuales
    print("pasajeros que suben: " + str(pasajeros_suben_escala))
    cantidad_actual=cantidad_actual+pasajeros_suben_escala  # calculo de la cantidad actual para escalada
    tiempo_escala=LGC_generator().getRamdon_glc(23) #escalas de no de mas de 24 horas
    # tiempo_usado = generate_lcg_valor(1, tiempo_restante)  # escalas de no de mas de 12 horas
    return pasajeros_bajan_escala,pasajeros_suben_escala,cantidad_actual,tiempo_escala
           # tiempo_usado

if __name__ == '__main__':
    calcularVuelo("bogota","paris",2000000,12,10,100)