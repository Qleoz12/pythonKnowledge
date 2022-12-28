import random

from fundamentals.encapsulation import CuentaFacebook, CuentaInstagram
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
    # lorenzo = Person("lorenzo", 12)
    # lorenzo.salario=10
    # lorenzo.saludar()
    #
    # carlos = Policia("carlos manrique", 25,50)
    # carlos.saludar()
    #
    # pedro = Enfermero("pedro",20,30)
    #
    # auxiliar1 = Auxiliar("pedro", 20,30)
    #
    # ## todos son personas
    # lista_personas = [lorenzo,carlos,pedro,auxiliar1]
    #
    # for i in lista_personas:
    #     deudas(i)

    lorenzo_facebook=CuentaFacebook("lorenzo","COL","lorenzoENZO","123")

    lorenzo_Insta = CuentaInstagram("lorenzo", "COL", "lorenzoENZO")

    # print(lorenzo_facebook.__password)

    print(lorenzo_facebook.obtenerCuenta())

    print(lorenzo_Insta._username)
    lorenzo_Insta.configurarClave("321")
    print(lorenzo_Insta.mostrarClave())

    lorenzo_Insta.getMarca()
    print(lorenzo_Insta._marca)


