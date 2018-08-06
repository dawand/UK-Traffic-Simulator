
# Predina iOS Engineer position tasks

## Running the server
Navigate to Scripts directory and run `python app.py` (requires Flask)
```sh
$ cd Scripts
$ python app.py
```
The server will start on http://localhost:5000/

Coordinates API link: http://localhost:5000/coordinates
Vehicle Realtime Location API link: http://localhost:5000/vehicles?time=05:00
(The current time will be fetched from the mobile device and sent as a time parameter, the realtime data only has time from 05:00 to 15:20)

## Local CSV files

You can also use the local CSV files to fetch the coordinates and vehicles data.
For that, you need to set `perform_locally` boolean to true in ```Configs.swift```

## Todos
 - Handle Internet disconnections
 - Add a loading spinner
 - Customise Tab icons
 - .....
