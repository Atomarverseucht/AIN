from statistics import quantiles
import matplotlib.pyplot as plt
import numpy
import scipy

x = numpy.array([4.2, 3.9, 4.3, 4.1, 4.1, 3.7, 4.3])
ad = numpy.array([9, 13, 15, 18, 20])
gh = numpy.array([18, 37, 61, 125, 59])
print(numpy.corrcoef(ad, gh))
print(scipy.stats.linregress(ad, gh))
print("-------")
print(numpy.mean(x))
print(numpy.median(x))
print(numpy.quantile(x, [0.25, 0.5, 0.75, 0.1]))
print(numpy.std(x, ddof=1))
#plt.boxplot(x)
#plt.show()