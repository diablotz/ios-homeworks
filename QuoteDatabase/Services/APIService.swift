//
//  APIService.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 22/07/26.
//

import Foundation


final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func loadRandomQuote(completion: @escaping(Result<ReceivedQuote, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.chucknorris.io/jokes/random")
        else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, _, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data else {return}
            
            do {
                
                let quote = try JSONDecoder().decode(ReceivedQuote.self, from: data)
                DispatchQueue.main.async{
                    completion(.success(quote))
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
}
