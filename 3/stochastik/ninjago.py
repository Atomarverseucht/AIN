import numpy
import pandas
import matplotlib.pyplot as plt
from matplotlib.pyplot import xticks

ninjago = pandas.read_csv("./ninjagokarten.csv", sep=';')
print(ninjago.head())
ninjago = ninjago.drop('Name', axis=1).values.transpose()
print(numpy.mean(ninjago, axis=1))
print(numpy.std(ninjago, axis=1, ddof=1))

color = (['yellow', 'red', 'blue', 'green'])
farbe = (['gelb', 'rot', 'blau', 'grün'])
for i in range(0,4):
    plt.scatter(numpy.full((1,ninjago[i].size), i), ninjago[i], color=color[i])
#plt.boxplot(ninjago.transpose())
xticks(range(1, 5), farbe)
plt.show()