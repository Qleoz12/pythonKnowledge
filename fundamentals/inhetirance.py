class Person:

    def __init__(self,name: str,age: int):
        self.name= name
        self.age = age

    # sobreescritura de un metodo nativo
    def __str__(self):
        return '<%s => %s>' % (self.__class__.__name__,self.name)

    #metodo de clase
    def saludar(self):
        print(" hola buen día  me llamo " + str(self.name) +" y tengo "+ str(self.age) +" años")

class Policia(Person):

    # sobreescritura del metodo de la clase padre
    def saludar(self):
        print(" buen día, cual es la emergencia ...")

