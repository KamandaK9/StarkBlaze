//
//  HousesTabViewModel.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import Foundation

final class HousesTabViewModel: ObservableObject {
    @Published private(set) var houses: [HousesModel] = []
    
    // Parsing set up
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        do {
            let houseList = try decoder.decode([HousesModel].self, from: json)
            houses = houseList
        } catch let error {
            print(error)
        }
    }
    

    // API call to fetch all houses
    func fetchAllHouses(page: Int, pageSize: Int) {
        let urlString = "https://www.anapioficeandfire.com/api/houses?page=\(page)&pageSize=\(pageSize)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching houses:", error)
                    return
                }
                
                if let data = data {
                    self?.parse(json: data)
                }
            }
            
            task.resume()
        }
    }
    
    
    // API Call for specific House search
    func fetchByHouse(_ name: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://anapioficeandfire.com/api/houses?name=\(encodedName)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching houses:", error)
                    return
                }
                
                if let data = data {
                    self?.parse(json: data)
                }
            }
            
            task.resume()
        }
    }
}
