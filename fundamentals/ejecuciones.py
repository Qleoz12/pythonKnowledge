import random

from fundamentals.inhetirance import Policia, Enfermero, Person, Auxiliar


def deudas( persona: Person):
    porcentaje_deuda=random.uniform(0.1, 1)
    print(porcentaje_deuda)
    print(persona.salario)
    print ("su deuda actual es "+ str(persona.salario*porcentaje_deuda))

if __name__ == '__main__':

    # bombero
    # policia
    # mesero
    lorenzo = Person("lorenzo", 12)
    lorenzo.salario=10
    lorenzo.saludar()

    carlos = Policia("carlos manrique", 25,50)
    carlos.saludar()

    pedro = Enfermero("pedro",20,30)

    auxiliar1 = Auxiliar("pedro", 20,30)

    ## todos son personas
    lista_personas = [lorenzo,carlos,pedro,auxiliar1]

    for i in lista_personas:
        deudas(i)


