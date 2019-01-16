
# UK Traffic Simulator

This iOS app displays the position of the vehicles on the UK map in realtime. Note that the data is not included as I do not have a copyright to use the data. You need to acquire the following CSV files:

1. The coordinates of the UK CSV file (Columns: Latitude and Longitude e.g. 51.341876, -0.061428)
2. The realtime location of vehicles in the UK (Columns: Time, Vehicle, Latitude, Longitude e.g. 05:00, Vehicle_1288, 51.793222, 0.129667)

## Running the server
Navigate to Scripts directory and run `python app.py`
```sh
$ cd TrafficSimulator/Scripts && python app.py
```
The server will start on http://localhost:5000/

Coordinates API link: http://localhost:5000/coordinates
Vehicle Realtime Location API link: http://localhost:5000/vehicles?time=05:00
(The current time will be fetched from the mobile device and sent as a time parameter, the realtime data only has time from 05:00 to 15:20)

## Running the app locally

You can also use the local CSV files to fetch the coordinates and vehicles data.
For that, you need to set `perform_locally` boolean to true in ```Configs.swift```

## Todos
 - Handle Internet disconnections
 - Add a loading spinner
 - Customise Tab icons
 - .....
