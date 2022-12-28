class CuentaFacebook:

    def __init__(self,name,pais,username,password):
        self.name=name
        self.pais=pais
        self._username=username  #protejido
        self.__password=password #privado
        self._marca="meta"         #protejido

    def obtenerCuenta(self):
        print("mi cuenta es {}  y , mi clave es ".format(self._username))

class CuentaInstagram(CuentaFacebook):

    def __init__(self,name,pais,username):
        self.name = name
        self.pais = pais
        self._username = username  # protejido

        CuentaFacebook.__init__(self,name,pais,username,"")


    ### setter
    def configurarClave(self,clave):
        if len(clave)<2:
            raise Exception("no es valido")

        self.__password=clave

    ### getter
    def mostrarClave(self):

        return self.__password

    def getMarca(self):
        print(self._marca)