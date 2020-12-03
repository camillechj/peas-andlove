import pandas as pd
from pandas import DataFrame

#read the pou files that you want
data = pd.read_csv('zssd.pou', delimiter= '\s+')

#select the columns
data_selected = data[['Run', 'Cycle', 'Environment', 'Individual', 'DF.1']]

data_selected.to_csv('removed.csv', index=False, header=False)

data = pd.read_csv('removed.csv')

#select the environment
data_field = data[data['Environment'] == 'Field']
#remove cycle 0
data_field = data_field[data_field['Cycle'] != 0]

data_field.to_csv('final.csv', index=False, header=True)

data_fifi = pd.read_csv('final.csv')
#calculate the mean of the phenotypic value of each individual in each cycle
df = DataFrame(data_fifi.groupby(['Cycle', 'Individual'])['PhenotypicValue'].mean())
#store the values, change the name according to different strategies
df.to_csv("phenotype_ssd.csv", index=True, header=True)