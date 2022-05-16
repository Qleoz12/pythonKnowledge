import numpy as np
from matplotlib import pyplot as plt

x0 = 0
y0 = -3
xf = 5
n = 6 #numerp de pasos es limite del conjunto +1
deltax = (xf-x0)/(n-1)
x = np.linspace(x0,xf,n)

def f(x,y):
	return x+(1/5)*y

y = np.zeros([n])
y[0] = y0

for i in range(1,n):
	y[i] = deltax*f(x[i-1],y0) + y0
	y0 = y[i]

print("x_n\t    y_n")
for i in range(n):
	print(x[i],"\t",format(y[i],'6f'))

plt.plot(x,y,'o')
plt.xlabel("Value of x")
plt.ylabel("Value of y")
plt.title("Approximation Solution with Euler's Method")
plt.show()