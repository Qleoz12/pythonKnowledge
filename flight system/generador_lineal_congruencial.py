from random import randrange

import pandas as pd
import matplotlib.pyplot as plt

class LGC_generator:

    def generate_lcg(self,num_iterations, xi,_a,_c,_m):
        """
        LCG - generates as many random numbers as requested by user, using a Linear Congruential Generator
        LCG uses the formula: X_(i+1) = (aX_i + c) mod m
        :param num_iterations: int - the number of random numbers requested
        :return: void
        """
        # Initialize variables
        x_value = xi  # Our seed
        a = _a
        c = _c  # Our "c" base value
        m = _m  # Our "m" base value
        d = []  #arreglo de valores calculados

        # counter for how many iterations we've run
        counter = 0

        # Open a file for output
        outFile = open("lgc_output.txt", "wb")

        #validations
        if _m==0:
          raise Exception('M', 'el parametro tiene un valor inadecuado')

        if _a<1 or _a>=_m :
          raise Exception('_a', 'el parametro debe ser menor al valor modulo de control')

        if _c<0 or _c>=_m-1:
          raise Exception('_c', 'el parametro debe ser menor al valor modulo de control menos 1 o superior a 0')

        # Perfom number of iterations requested by user
        while counter < num_iterations:
            # Store value of each iteration
            x_value = (a * x_value + c) % m

            # Obtain each number in U[0,1) by diving X_i by m
            writeValue = str(x_value / m)
            d.append({
                'i': counter,
                'x': writeValue,
                'a': a,
                'c': c,
                'm': m,
            })
            # write to output file
            outFile.write((writeValue + "\n").encode())
            # print "num: " + " " + str(counter) +":: " + str(x_value)
            counter = counter + 1

        outFile.close()
        df = pd.DataFrame(d)
        print("Successfully stored " + str(num_iterations) + " random numbers in file named: 'lgc_output.txt'.")
        # print(df)
        df = df.sort_values('x') # se ordena la columna
        ax2 = df.plot.scatter(x='i',y = 'x',colormap = 'viridis')
        fig = ax2.get_figure()
        fig.set_size_inches(16.5, 16)  # ajustar tamaño de grafica
        plt.savefig("test", dpi=300)
        plt.close()

        fig, ax = plt.subplots()
        ax.axis('tight')
        ax.axis('off')
        plt.tight_layout()
        df = df.sort_values('i')  # se ordena la columna
        fig.set_size_inches(5, 18)  # ajustar tamaño de grafica
        ax.table(cellText=df.values, colLabels=df.columns, loc='center')
        plt.savefig("table", dpi=300)
        plt.close()


    def getRamdon_glc(self,numero):
        xi=randrange(numero)
        _a=randrange(1,numero-1)
        _c = randrange(0, numero-1)
        _m=numero
        numero_ramdom= self.generate_lcg_valor(xi, _a, _c, _m)
        return numero_ramdom


    def generate_lcg_valor( self,xi,_a,_c,_m):
        """
        LCG - generates as many random numbers as requested by user, using a Linear Congruential Generator
        LCG uses the formula: X_(i+1) = (aX_i + c) mod m
        _a multiplicador
        _c incremento
        _m limite rango
        :param num_iterations: int - the number of random numbers requested
        :return: void
        """
        # Initialize variables
        x_value = xi  # Our seed
        a = _a
        c = _c  # Our "c" base value
        m = _m  # Our "m" base value
        d = []  #arreglo de valores calculados

        # counter for how many iterations we've run
        counter = 0

        # Open a file for output
        outFile = open("lgc_output.txt", "wb")

        #validations
        if _m==0:
          raise Exception('M', 'el parametro tiene un valor inadecuado')

        if _a<1 or _a>=_m :
          raise Exception('_a', 'el parametro debe ser menor al valor modulo de control')

        if _c<0 or _c>=_m-1:
          raise Exception('_c', 'el parametro debe ser menor al valor modulo de control menos 1 o superior a 0')

        # Perfom number of iterations requested by user
        x_value = (a * x_value + c) % m
        return x_value


if __name__ == "__main__":

        #LGC
        # repeticiones=99
        # seed = 59        # semilla dentro del rango entre 0  y la variable de control modulo ->M
        # a = 21              #multiplicados
        # c = 13               #incremento
        # M = 100             # variable de control
        # generate_lcg(repeticiones,seed,a,c,M)

        # LGC multiplicativo
        # repeticiones = 99
        # seed = 12  # semilla dentro del rango entre 0  y la variable de control modulo ->M
        # a = 21  # multiplicados
        # c = 0  # incremento
        # M = 100  # variable de control
        # generate_lcg(repeticiones, seed, a, c, M)

        print(LGC_generator().getRamdon_glc(12))
        print(LGC_generator().getRamdon_glc(12))
        print(LGC_generator().getRamdon_glc(12))