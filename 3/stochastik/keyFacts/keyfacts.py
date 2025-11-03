import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from docutils.nodes import legend

pcs = pd.read_csv('./computer_prices_all.csv').drop(columns=['model', 'warranty_months', 'bluetooth', 'wifi','resolution']).drop(columns=['psu_watts', 'charger_watts', 'battery_wh', 'refresh_hz'])
pcs = pcs.drop(columns=['gpu_model','release_year','storage_drive_count'])
nnomPcs = pcs.drop(columns=["device_type","brand","os","form_factor","cpu_brand","cpu_model","gpu_brand","storage_type","display_type"])
print(nnomPcs.head(n = 0))
h = nnomPcs.values.transpose()
r = range(0,5)
ind = [1,2,8,10,11]

for i in r:
    plt.violinplot(h[ind[i]], [i], widths=1.2)
    #plt.scatter(np.full((1,h[i].size), i), h[i])
plt.xticks(r, nnomPcs.columns[ind])
plt.yscale('log')
plt.show()