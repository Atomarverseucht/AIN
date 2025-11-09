import statistics
import numpy as np

java = np.array([9, 11, 9, 21, 16, 13, 0])

print("Aufgabe 1.11.1: ")
print(statistics.mode(java))
print(np.mean(java))
print(np.median(java))
quant = np.quantile(java, q=[0.9, 0.25, 0.5, 0.75])
print(quant[0])
print(np.std(java, ddof=1))
print(quant)
print((quant[3] - quant[1]))
print((np.max(java) - np.min(java)))