from statistics import quantiles
import matplotlib.pyplot as plt
import numpy
x = numpy.array([14, 24, 22, 19, 18, 36, 15, 29, 41, 17])
print(numpy.mean(x))
print(numpy.quantile(x, [0.25, 0.5, 0.75, 0.9]))
print(numpy.std(x, ddof=1))
plt.boxplot(x)
plt.show()