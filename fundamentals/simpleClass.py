"""
clase =
objeto =

sobreesritura =
"""



class perrito:
    pass

class gato:
    pass

class tortuga:
    pass

class Person:

    def __init__(self,name,age):
        self.name= name
        self.age = age

    # sobreescritura de un metodo nativo
    def __str__(self):
        return '<%s => %s>' % (self.__class__.__name__,self.name)

    #metodo de clase
    def saludar(self):
        print(" hola buen día  me llamo " + self.name +" y tengo "+ str(self.age) +" años")


def mysaludo(name : str ,edad: int,forma: str):
    print(forma.format(name,edad))

if __name__ == '__main__':

    lorenzo = Person("lorenzo",15)

    pablo = Person("juan", 30)

    saludo = "¿ Qué me cuentas?  me recuerdas  soy {}  de {}  "
    #
    # print(lorenzo.name)
    # print(lorenzo.age)
    #
    # print(lorenzo.__str__())
    #
    # print(pablo.__str__())
    #
    # lorenzo.saludar()
    #
    # pablo.saludar()
    #
    list_personas=[lorenzo,pablo]

    # iterador
    for i in list_personas:
        i.saludar()
        mysaludo(i.name,i.age,saludo)



