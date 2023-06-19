//
//  CharacterTabViewModel.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import Foundation


final class CharacterTabViewModel: ObservableObject {
    @Published private(set) var characters: [CharactersModel] = []
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        do {
            let characterlist = try decoder.decode([CharactersModel].self, from: json)
            characters = characterlist
        } catch let error {
            print(error)
        }
    }

    
    // API Call to fetch all characters. Page and PageSize are taken as arguement. they an be adjusted on the Character ViewController
    func fetchAllCharacters(page: Int, pageSize: Int) {
        let urlString = "https://www.anapioficeandfire.com/api/characters?page=\(page)&pageSize=\(pageSize)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching characters:", error)
                    return
                }
                
                if let data = data {
                    self?.parse(json: data)
                }
            }
            
            task.resume()
        }
    }
    
    // API Call to fetch a specific character name
    func fetchCharacterName(_ name: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://anapioficeandfire.com/api/characters?name=\(encodedName)"
        print(urlString)
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching character:", error)
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
