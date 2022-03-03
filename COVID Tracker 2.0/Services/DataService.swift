//
//  DataService.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/20/22.
//

import Foundation

class DataService {
    func requestData(_ url: String, completion: @escaping ((Data) -> Void)) {
        guard let url = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                completion(data)
            }
            else if let error = error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
