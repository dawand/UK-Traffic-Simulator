//
//  ServiceManager.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 06/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation

class ServiceManager: NSObject {
    
    //  Static Instance variable for Singleton
    static var shared = ServiceManager()
    
    //  Preventing initialisation from any other source.
    private override init() {
        
    }
    
    //  Function to execute GET request and pass data from escaping closure
    func executeGetRequest(with urlString: String, completion: @escaping (Data?) -> ()) {
        
        let url = URL.init(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            //  Log errors (if any)
            if error != nil {
                debugPrint(error.debugDescription)
            } else {
                //  Passing the data from closure to the calling method
                completion(data)
            }
            }.resume()  // Starting the dataTask
    }
    
    func getCoordinates(from urlString: String, completion: @escaping ([Coordinate]) -> ()) {
        //  Calling executeGetRequest(with:)
        executeGetRequest(with: urlString) { (data) in  // Data received from closure
            do {
                //  JSON parsing
                let decoder = JSONDecoder()
                let result = try decoder.decode([Coordinate].self, from: data!)
                
                completion(result)
            } catch {
                debugPrint("ERROR: could not retrieve coordinates")
            }
        }
    }
    
    func getVehicles(from urlString: String, completion: @escaping ([Vehicle]) -> ()) {
        //  Calling executeGetRequest(with:)
        executeGetRequest(with: urlString) { (data) in  // Data received from closure
            do {
                
                //  JSON parsing
                let decoder = JSONDecoder()
                let result = try decoder.decode([Vehicle].self, from: data!)
                
                completion(result)
            } catch {
                debugPrint("ERROR: could not retrieve response")
            }
        }
    }
}
