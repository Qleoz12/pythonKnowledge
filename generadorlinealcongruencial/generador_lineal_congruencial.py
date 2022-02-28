import cairo

import pandas as pd


import matplotlib.pyplot as plt


class LGC_generator:

    def generate_lcg(num_iterations, xi,_a,_c,_m):
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
        d = []

        # counter for how many iterations we've run
        counter = 0

        # Open a file for output
        outFile = open("lgc_output.txt", "wb")

        #validations
        if _m==0:
          raise Exception('M', 'el parametro tiene un valor inadecuado')

        if _a<1 or _a>=_m :
          raise Exception('_a', 'el parametro debe ser menor al valor modulo de control')

        if _c<1 or _c>=_m-1:
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
            df=pd.DataFrame(d)

            # write to output file
            outFile.write((writeValue + "\n").encode())
            # print "num: " + " " + str(counter) +":: " + str(x_value)

            counter = counter + 1

        outFile.close()
        print("Successfully stored " + str(num_iterations) + " random numbers in file named: 'lgc_output.txt'.")
        print(df)
        # ax2 = df.plot.scatter(x='i',y = 'x',colormap = 'viridis')
        df.sort_values('x')
        print(df.sort_values('x'))

        df.sort_values('x').plot(x='i', y='x', kind='scatter')
        fig = plt.gcf()
        fig.set_size_inches(16.5, 16)
        plt.savefig("test",dpi=300)



    if __name__ == "__main__":
        repeticiones=100
        seed = 1
        a = 21
        c = 1
        M = 100
        generate_lcg(repeticiones,seed,a,c,M)

        with cairo.SVGSurface("example.svg", 200, 200) as surface:
            context = cairo.Context(surface)
            x, y, x1, y1 = 0.1, 0.5, 0.4, 0.9
            x2, y2, x3, y3 = 0.6, 0.1, 0.9, 0.5
            context.scale(200, 200)
            context.set_line_width(0.04)
            context.move_to(x, y)
            context.curve_to(x1, y1, x2, y2, x3, y3)
            context.stroke()
            context.set_source_rgba(1, 0.2, 0.2, 0.6)
            context.set_line_width(0.02)
            context.move_to(x, y)
            context.line_to(x1, y1)
            context.move_to(x2, y2)
            context.line_to(x3, y3)
            context.stroke()