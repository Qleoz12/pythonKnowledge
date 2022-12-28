from abc import ABC, abstractmethod

# interface no tiene implementacion
"""*******************************************"""
class Comportamientodejovenes(ABC):

    @abstractmethod
    def chatear(self):
        pass

    @abstractmethod
    def crearVideos(self):
        pass

class ComportamientodejovenEstudioso(ABC):

    @abstractmethod
    def aprender(self):
        pass



class aves(ABC):

    @abstractmethod
    def volar(self):
        pass

"""*******************************************"""


# clase que usa una interface -  implementa 2  interface
"""*******************************************"""
class JovenClaseMedia(Comportamientodejovenes):

    def __init__(self,name):
        self.name=name

    def saludo(self):
        pass

    def chatear(self):
        print("chateo mucho")

    def crearVideos(self):
        print("creo muchos videos")

class JovenClaseAlta(Comportamientodejovenes,ComportamientodejovenEstudioso):

    def __init__(self,name):
        self.name=name

    def saludo(self):
        pass

    def aprender(self):
        print("yo si aprendeo de forma virtual")

    def chatear(self):
        print("chateo poco")

    def crearVideos(self):
        print("creo muchos videos")

"""*******************************************"""



if __name__ == '__main__':
    lorenzo=JovenClaseAlta("andres")

    lorenzo.chatear()
    lorenzo.crearVideos()
    lorenzo.aprender()


    print("-----------------------------------------------------------------")
    pablo = JovenClaseMedia("pablo")

    pablo.crearVideos()
    pablo.chatear()



