//
//  Constants.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 11/29/21.
//

import Foundation
import CSV

struct Const {
    struct CountryData {
        struct USA {
            private static func coordinatesOfStates() -> [String:Coodinate] {
                var coordinates = [String:Coodinate]()
                guard let filePath = Bundle.main.url(forResource: "statelatlong", withExtension: "csv") else {
                    return [:]
                }
                if let stream = InputStream(fileAtPath: filePath.path) {
                    do {
                        let reader = try CSVReader(stream: stream, hasHeaderRow: true)
                        let arrOfDict = reader.map(self.createDict)
                        
                        coordinates = arrOfDict.flatMap({$0}).reduce([String:Coodinate]()) { (dict, tuple) in
                            var nextDict = dict
                            nextDict[tuple.0] = tuple.1
                            return nextDict
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    print("Error: Inputstream")
                }
                
                return coordinates
            }
            static func getCoordinate(state: String) -> Coodinate?{
                let coordinates = self.coordinatesOfStates()
                return coordinates[state]
            }
            private static func createDict(row: [String]) -> [String:Coodinate] {
                let name = row[0]
                let lat = Float(row[1]) ?? 0
                let long = Float(row[2]) ?? 0
                let location = Coodinate(lat: lat, long: long)
                return [name : location]
            }
        }
        
    }
}
