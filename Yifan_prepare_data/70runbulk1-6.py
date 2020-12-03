import pandas as pd
from pandas import DataFrame

#this is time consuming, so combine 6 cycles each time,
for i in range(1,7):
    dfs = []
    for j in range(1,71):
        df = pd.read_csv('run' + str(j) + 'cycle' + str(i) + '.csv')
        dfs.append(df)

    total = []
    #change this value of k to match the individual number in each cycle (maximum value)
    for k in range(6120):
        data = []
        #change this value of l to match the number of qtls and markers
        for l in range(1027):
            dic = {'0': 0, '1': 0, '2': 0}
            for m in range(len(dfs)):
                if (int(dfs[m].iloc[k,l]) == 1 or int(dfs[m].iloc[k,l]) == 2 or int(dfs[m].iloc[k,l]) == 0):
                    dic[str(int(dfs[m].iloc[k,l]))] += 1
            max_num = max(dic, key=dic.get)
            data.append(max_num)
        total.append(data)
    #store the data
    dff = DataFrame (total)
    dff.to_csv('cycle' + str(i) + 'results.csv', index=False, header=True)
