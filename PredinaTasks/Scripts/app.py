#!flask/bin/python

from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return "Select coordinates /coordinates or Realtime Location /realtime"

from updateCoordinateColor import getNewCoordinateColors
@app.route('/coordinates')
def get_coordinates():
    coordinates = getNewCoordinateColors()
    return coordinates

from flask import request
from getVehicleData import getVehicleData
@app.route('/vehicles')
def get_vehicles():
    time = request.args['time']
    vehicles = getVehicleData(time)
    return vehicles

if __name__ == '__main__':
    app.run(host="0.0.0.0", port="5000")