import numpy as np
import matplotlib.pyplot as plt

x = np.array([3, 4, 5, 1, 5, 2, 1, 3, 1, 3, 3, 3, 2, 1, 5])
n = np.unique(x)
bc = np.bincount(x)
p = bc / x.size                     # relative Häufigkeit
val = range(0, n.max() + 1)
dist = 0.1                          # Abstand zu bars

plt.xlabel("Werte")
plt.ylabel("absolute Wahrscheinlichkeit")
plt.bar(val, bc)
plt.show()