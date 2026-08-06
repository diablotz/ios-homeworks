//
//  WeatherService.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 03/08/26.
//

import Foundation
import Alamofire

final class WeatherService {
    static let shared = WeatherService()
    
    private init() {}
    
    nonisolated func loadCurrentWeather(
        latitude: Double,
        longitude: Double,
        completion: @escaping @Sendable (Result<CurrentWeatherResponse, Error>) -> Void
    ) {
        let url = "\(Constants.weatherURL)/weather"
        
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": Constants.apiKey,
            "units": "metric",
            "lang": "ru"
        ]
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: CurrentWeatherResponse.self) { response in
                switch response.result {
                    case .success(let weather):
                        completion(.success(weather))
                    
                    case .failure(let error):
                        print(error)
                        completion(.failure(error))
                }
            }
    }
    
}
