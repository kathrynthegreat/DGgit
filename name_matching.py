import pandas as pd
import numpy as np
import nltk.metrics as metrics
from difflib import SequenceMatcher as SM


df = pd.read_csv('NameMatch.csv')
n1 = df.SHGVillage.dropna()
n2 = df.FinalVillage.dropna()
#n2 = map(str.upper, n2)

df_new = pd.DataFrame(index = range(len(n1)))
df_new['SHGVillage'] = n1 


min_ndx = []
min_scores = []
name_match1 = []	
name_match2 = []
name_match3 = []
name_match4 = []
name_match5 = []

for name in n1:

	distance = []
	distance = np.array(distance)

	for name_test in n2:
		distance = np.append(distance, metrics.edit_distance(name, name_test))

	sorted_ndx = np.argsort(distance)
	name_match1.append(n2[sorted_ndx[0]])
	name_match2.append(n2[sorted_ndx[1]])
	name_match3.append(n2[sorted_ndx[2]])
	name_match4.append(n2[sorted_ndx[3]])
	name_match5.append(n2[sorted_ndx[4]])

df_new['Final0'] = name_match1
df_new['Final1'] = name_match2
df_new['Final2'] = name_match3
df_new['Final3'] = name_match4
df_new['Final4'] = name_match5

df_new.to_csv('df_new.csv')