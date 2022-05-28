from random import randrange

import numpy as np

from generador_lineal_congruencial import LGC_generator
import matplotlib.pyplot as plt


def calcularVuelo(pais_origen,pais_destino,precio_directo,tiempo_estimado_total,escalas,cantidad):
    print(cantidad, tiempo_estimado_total)
    costonicial=precio_directo/cantidad
    cantidad_total=cantidad
    cantidad_actual = cantidad
    tiempo_escala=0
    valor_total_vuelo=0
    valor_escalada = 0
    valor_beneficio=0
    Matrix = [[0 for x in range(3)] for y in range(escalas)]
    if escalas==0 :
        return  {
            "pais_origen": pais_origen,
            "pais_destino": pais_destino,
            "precio": precio_directo,
            "tiempo": tiempo_estimado_total,
            "pasajeros": cantidad
        }
    if escalas>0:
        for x in range(escalas):
            print("escala : "+str(x+1))
            print("escala info: " + str(escalas-x))
            print(cantidad_total, cantidad_actual, tiempo_estimado_total, tiempo_escala)
            valor_por_hora = precio_directo / (tiempo_estimado_total/(escalas-x))
            valor_por_persona = precio_directo / cantidad_actual
            valor_escalada=(valor_por_hora+valor_por_persona)/2
            valor_total_vuelo+=valor_escalada
            valor_beneficio+=(valor_escalada-(costonicial/escalas))
            Matrix[x][0]=(valor_escalada-(costonicial/escalas))
            Matrix[x][1]=valor_escalada
            Matrix[x][2] = costonicial
            print("precio hasta escalada "+str(valor_escalada))
            print("beneficio " + str((valor_escalada-(costonicial/escalas))))
            _, _, cantidad_actual, tiempo_escala = calcular_escala(tiempo_estimado_total, cantidad_total,cantidad_actual)
            print("tiempo trayecto  " +str(tiempo_estimado_total/(escalas-x)))
            print("tiempo escala  " + str(tiempo_escala))
            print(tiempo_estimado_total)
            # tiempo_estimado_total-=(tiempo_estimado_total/(tiempo_estimado_total/(escalas-x))) #resto de trayecto consumido
            print(tiempo_estimado_total)
            tiempo_estimado_total+=tiempo_escala #sumo tiempo de escala

            print("---------------------------------------------------------------------------------------------------")

    print("valor final de vuelo "+str(valor_total_vuelo))
    print(Matrix)

    data = np.array(Matrix)
    x = np.arange(data.shape[0])
    dx = (np.arange(data.shape[1]) - data.shape[1] / 2.) / (data.shape[1] + 2.)
    d = 1. / (data.shape[1] + 2.)
    print(data)
    fig, ax = plt.subplots()
    labels = ['beneficio', 'cobro escalada ','costo']
    for i in range(data.shape[1]):
        ax.bar(x + dx[i], data[:, i], width=d, label=labels[i])

    fig.set_size_inches(18.5, 10.5)
    plt.legend(framealpha=1)
    plt.savefig("flight", dpi=300)
    plt.close()




def calcular_escala(tiempo_restante,cantidad_total,cantidad_actual):
    tiempo_escala=0
    tiempo_usado=0

    pasajeros_bajan_escala=LGC_generator().getRamdon_glc(cantidad_actual)
    print("pasajeros que bajan: "+ str(pasajeros_bajan_escala))
    cantidad_actual=cantidad_actual-pasajeros_bajan_escala
    pasajeros_suben_escala =LGC_generator().getRamdon_glc(cantidad_total-cantidad_actual)
    print("pasajeros que suben: " + str(pasajeros_suben_escala))
    cantidad_actual=cantidad_actual+pasajeros_suben_escala
    tiempo_escala=LGC_generator().getRamdon_glc(23) #escalas de no de mas de 24 horas
    # tiempo_usado = generate_lcg_valor(1, tiempo_restante)  # escalas de no de mas de 12 horas
    return pasajeros_bajan_escala,pasajeros_suben_escala,cantidad_actual,tiempo_escala
           # tiempo_usado

if __name__ == '__main__':
    calcularVuelo("bogota","paris",2000000,12,10,100)