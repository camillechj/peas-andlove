import pandas as pd
from pandas import DataFrame

#read txt files
data = pd.read_csv('pou-mod.txt')
#select the columns that you need
data_selected = data[['Run','Cycle','Individual','Phenotypic']]
#calculate the mean value of the phenotypic values according to each individual in each group
df = DataFrame(data_selected.groupby(['Cycle', 'Individual'])['Phenotypic'].mean())

#store the result as the csv file
df.to_csv("phenotype_mod.csv", index=True, header=True)