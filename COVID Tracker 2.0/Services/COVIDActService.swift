//
//  COVIDActservice.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/3/22.
//

import Foundation

class COVIDActService {
    var completion: (([Region]) -> Void)?
    static let shard = COVIDActService()
    let url = URL(string: "https://api.covidactnow.org/v2/states.timeseries.json?apiKey=46bd2998087549d8af76d05823dd40a5")
    
    public func fetchUSData(completion: @escaping ([Region]) -> Void) {
        self.completion = completion
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode([Region].self, from: data)
                
                self.addStateCoordinate(result)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    private func addStateCoordinate(_ result: [Region]) {
        let states = result.map(Region.createNewUSA)
        DispatchQueue.global().async {
            self.completion?(states)
        }
    }
}
