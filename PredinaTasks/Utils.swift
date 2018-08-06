//
//  Utils.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation

class Utils {
    
    // used for reading coordinates locally
    class func readDataFromCSV(fileName:String, fileType: String)-> [[String]]! {
        
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                debugPrint("\(fileName) does not exist!")
                return nil
        }
        
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            
            var result: [[String]] = []
            let rows = contents.components(separatedBy: "\n")
            for row in rows {
                let columns = row.components(separatedBy: ",")
                result.append(columns)
            }
            return result
            
        } catch {
            debugPrint("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    // used for reading real time location of vehicles locally for a particlar hh:mm
    class func readDataFromCSVForTime(fileName:String, fileType: String, time: String)-> [[String]]!{
        
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                debugPrint("\(fileName) does not exist!")
                return nil
        }
        
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
           
            var result: [[String]] = []
            let rows = contents.components(separatedBy: "\n")
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                
                // check if current time is equal to recorded time
                if columns[0] == time {
                    result.append(columns)
                }
            }
            
            return result
        } catch {
            debugPrint("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    // return current HH:mm
    class func getCurrentTime() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let timeString = formatter.string(from: Date())
        
        debugPrint(timeString)
        
        return timeString
    }
}
