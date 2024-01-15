# Trabajando con la función OPEN()

# Abrir el archivo en modo de lectura (r)
my_file = open("my_file.txt", "r")

#Leer el contenido de nuestro archivo y almacenarlo en la variable
content_file = my_file.read()

#Cerrar el archivo para liberar recurso
my_file.close()

#Mostrar el contenido del archivo
print(content_file)