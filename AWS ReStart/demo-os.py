import os

actual = os.getcwd()
print(f'El directorio actual es: {actual}')

nameFile = "myFile"
os.mkdir(nameFile)
print(f'Se ha creado la carpeta {nameFile} en el directorio actual')

contDirectory = os.listdir()
print(f'Contenido del directorio actual: {contDirectory}')

os.remove(nameFile)
print(f'Se ha eliminado la carpeta {nameFile} en el directorio actual')

contDirectory = os.listdir()
print(f'Contenido del directorio actual: {contDirectory}')

print(f'El usuario actual es:')
user = os.system("whoami")