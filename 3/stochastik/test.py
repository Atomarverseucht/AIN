import scipy
import sys
import random
import matplotlib.pyplot as mpl 

x = [0,0,0,0,0,0]
y = 20
for i in range(0, y):
    h = random.randint(0,5)
    x[h] += 1

mpl.plot(range(1,7), x)

mpl.ylabel('Anzahl Würfe')
mpl.xlabel('Würfelwert')
mpl.ylim(bottom=0)
mpl.show()    