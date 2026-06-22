//
//  NetworkService.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 22/06/26.
//

import Foundation

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        
        let url: URL

        switch configuration {
        case .people(let peopleURL):
            url = peopleURL
        case .starships(let starshipsURL):
            url = starshipsURL
        case .planets(let planetsURL):
            url = planetsURL
        
        }
        
    URLSession.shared.dataTask(with: url) { (data, response, error) in
            // ошибка
        if let error = error {
            print("Ошибка: \(error), код: \(error.localizedDescription) ")
            return
        }
        /* Информация, получаемая при выключенном интернете
         Ошибка: Error Domain=NSURLErrorDomain Code=-1009 "The Internet connection appears to be offline." UserInfo={_kCFStreamErrorCodeKey=50, NSUnderlyingError=0x600000c27b40 {Error Domain=kCFErrorDomainCFNetwork Code=-1009 "(null)" UserInfo={_kCFStreamErrorDomainKey=1, _kCFStreamErrorCodeKey=50, _NSURLErrorNWResolutionReportKey=Resolved 0 endpoints in 0ms using unknown from cache, _NSURLErrorNWPathKey=unsatisfied (No network route)}}, _NSURLErrorFailingURLSessionTaskErrorKey=LocalDataTask <0B12E2F3-B42D-4F0C-9C0D-32BE75568EE0>.<1>, _NSURLErrorRelatedURLSessionTaskErrorKey=(
             "LocalDataTask <0B12E2F3-B42D-4F0C-9C0D-32BE75568EE0>.<1>"
         ), NSLocalizedDescription=The Internet connection appears to be offline., NSErrorFailingURLStringKey=https://jsonplaceholder.typicode.com/posts/2, NSErrorFailingURLKey=https://jsonplaceholder.typicode.com/posts/2, _kCFStreamErrorDomainKey=1}, код: The Internet connection appears to be offline.
         
         
         */
        
        // ответ от сервера
        if let response = response as? HTTPURLResponse{
            print("Ответ: \(response)")
            print("Код: \(response.statusCode)")
            print ("Headers: \(response.allHeaderFields)")
        }
        
        // Данные
        if let data = data {
            print("Data: \(data)")
        }
        
    }.resume()
        
    }
}
