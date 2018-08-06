import numpy as np
import pandas as pd

def getNewCoordinateColors():
    csvfile = "../PredinaTasks/Resources/Coordinates_100.csv"
    df = pd.read_csv(csvfile)
    df['Color'] = np.random.randint(1, 10, size=len(df))
    df_json = df.to_json(orient='records')
    return df_json
