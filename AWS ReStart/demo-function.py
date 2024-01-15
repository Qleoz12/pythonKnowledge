#Representar algunas funciones

"""def sum_values(a=2,b=5):
    total = a + b
    return total

valueTotalSumValues = sum_values(10,20)

print(valueTotalSumValues)

#Función que calcule el area de un circulo
pi = 3.14159

def calculate_area(r):
    areaTotal = pi*r**2
    return areaTotal

requestNum = int(input("Ingresa un radio de circulo:"))

totalArea = calculate_area(requestNum)
print(totalArea)"""

def sayHello():
    print("Hola, espero que se encuentre muy bien")

sayHello()

def areaRect(base, altura):
    areaTotal = base * altura
    return areaTotal

area = areaRect(4,5)
print(f"El area del rectangulo es: {area}")