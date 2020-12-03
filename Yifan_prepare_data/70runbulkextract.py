import pandas as pd
from pandas import DataFrame

#read those pop files, change the name "zbulk" to the strategy that you are working with
#change i which is the number of runs
#change j which is the number of cycles
for i in range(1, 71):
    for j in range(1,31):
        if (i < 10):
            if (j < 10):
                file1 = open('zbulk_001_001_00' + str(i) + '_00' + str(j) + '.pop', 'r')
            elif (j >= 10):
                file1 = open('zbulk_001_001_00' + str(i) + '_0' + str(j) + '.pop', 'r')
        elif (i >= 10 and i < 100):
            if (j < 10):
                file1 = open('zbulk_001_001_0' + str(i) + '_00' + str(j) + '.pop', 'r')
            elif (j >= 10):
                file1 = open('zbulk_001_001_0' + str(i) + '_0' + str(j) + '.pop', 'r')
        else:
            if (j < 10):
                file1 = open('zbulk_001_001_' + str(i) + '_00' + str(j) + '.pop', 'r')
            elif (j >= 10):
                file1 = open('zbulk_001_001_' + str(i) + '_0' + str(j) + '.pop', 'r')

        non_empty_lines = [line for line in file1 if line.strip() != ""]

        string_without_empty_lines = ""
        for line in non_empty_lines:
            string_without_empty_lines += line + "/n"

        lines = string_without_empty_lines.split("/n")
        newData = []
        #read the data
        for k in range(12, len(lines)-1, 2):
            indi = []
            for l in range(len(lines[k])):
                if (lines[k][l] == '1' and lines[k + 1][l] == '1'):
                    indi.append('0')
                if ((lines[k][l] == '1' and lines[k + 1][l] == '2') or (lines[k][l] == '2' and lines[k + 1][l] == '1')):
                    indi.append('1')
                if (lines[k][l] == '2' and lines[k + 1][l] == '2'):
                    indi.append('2')
            newData.append(indi)
        #change the value here according to the maximum number of individuals that each cycle has
        if (len(newData) < 6120):
            for k in range(len(newData), 6120):
                indi = []
                #this value is the number of markers and the qtls, you may change here
                for l in range(1027):
                    indi.append('3')
                newData.append(indi)

        #store the results of each cycle for each run, then use those 70runbulk files to get the final results
        df = DataFrame(newData)
        df.to_csv('run' + str(i) + 'cycle' + str(j) + '.csv', index=False, header=True)
