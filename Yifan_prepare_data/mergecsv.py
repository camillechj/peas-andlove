import os, glob
import pandas as pd


#download the genotypic results of all cycles, combine them to a single final csv file
os.chdir("E:/project data/flowerssd")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
combined_csv = pd.concat([pd.read_csv(f) for f in all_filenames ])
#export to csv
combined_csv.to_csv("combined_csv.csv", index=False, encoding='utf-8-sig')
