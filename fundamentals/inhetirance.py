class Person:

    def __init__(self,name: str,age: int,salario=0):
        self.name= name
        self.age = age
        self.salario=salario

    # sobreescritura de un metodo nativo
    def __str__(self):
        return '<%s => %s>' % (self.__class__.__name__,self.name)

    #metodo de clase
    def saludar(self):
        print(" hola buen día  me llamo " + str(self.name) +" y tengo "+ str(self.age) +" años")

    def mysalario(self):
        print(" hola mi salario es " + str(self.salario))

class Policia(Person):

    # sobreescritura del metodo de la clase padre
    def saludar(self):
        print(" buen día, cual es la emergencia ...")

    def mysalario(self):
        print(" hola mi salario es " + str(self.salario*1.1))

class Auxiliar(Policia):

    # sobreescritura del metodo de la clase padre
    def saludar(self):
        print(" buen día, cual es la emergencia ...")

    def mysalario(self):
        print(" hola mi salario es " + str(self.salario*1.1))



class Enfermero(Person):

    # sobreescritura del metodo de la clase padre
    def saludar(self):
        print(" buen día, buenvenido al hospital ...")

    def mysalario(self):
        print(" hola mi salario es " + str(self.salario*0.9))


