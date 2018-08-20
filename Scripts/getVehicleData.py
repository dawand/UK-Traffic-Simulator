import pandas as pd

def getVehicleData(time):
    csvfile = "../PredinaTasks/Resources/realtimelocation.csv"
    df = pd.read_csv(csvfile)
    df = df.loc[df['Time'] == time]   
    df_json = df.to_json(orient='records')
    return df_json
