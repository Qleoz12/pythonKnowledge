import numpy as np
import matplotlib.pyplot as plt

# Fixed sample size
n = 120

# Generate p values from 0 to 1
p = np.linspace(0.001, 0.999, 1000)

# Compute standard deviation of p-hat
sd = np.sqrt((p * (1 - p)) / n)

# Create the plot
plt.figure()
plt.plot(p, sd)

plt.title("Standard Deviation of Sample Proportion (n = "+str(n)+")")
plt.xlabel("Population Proportion (p)")
plt.ylabel("SD(p-hat)")
plt.grid(True)

plt.show()