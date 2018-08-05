import pandas
import random

csvfile = "Coordinates.csv"
outputfile = "Coordinates_100.csv"

n = sum(1 for line in open(csvfile)) - 1 #number of records in file (excludes header)
s = 100 #desired sample size
skip = sorted(random.sample(xrange(1,n+1),n-s)) #the 0-indexed header will not be included in the skip list

df = pandas.read_csv(csvfile, skiprows=skip)
df.to_csv(outputfile, mode = 'w', index=False)
