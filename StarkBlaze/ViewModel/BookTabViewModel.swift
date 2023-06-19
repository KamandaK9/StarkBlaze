//
//  BookTabViewModel.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import Foundation


final class BookTabViewModel: ObservableObject {
    @Published private(set) var books: [BookModel] = []
    
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        do {
            let booklist = try decoder.decode([BookModel].self, from: json)
            books = booklist
        } catch let error {
            print(error)
        }
    }
    
    func fetchAllBooks(page: Int, pageSize: Int) {
        let urlString = "https://anapioficeandfire.com/api/books?page=\(page)&pageSize=\(pageSize)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching books:", error)
                    return
                }
                
                if let data = data {
                    self?.parse(json: data)
                }
            }
            
            task.resume()
        }
    }
    
    func fetchBooksByName(_ name: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://anapioficeandfire.com/api/books?name=\(encodedName)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching books:", error)
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
