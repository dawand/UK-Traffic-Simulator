//
//  configs.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 06/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation

// change to true to fetch the data from the local CSV files and update the coordinate colours locally
let perform_locally = false

// API call links
let base_url = "http://localhost:5000"
let coordinates_api_link = "\(base_url)/coordinates"
let vehicles_api_link = "\(base_url)/vehicles?time="

// number of rows for coordinates in the local CSV file
let sample_size = 100
