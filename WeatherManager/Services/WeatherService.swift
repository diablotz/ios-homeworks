////
////  WeatherService.swift
////  WeatherManager
////
////  Created by Timur Zakirov on 03/08/26.
////
//


import Foundation
import Alamofire

final class WeatherService {
    static let shared = WeatherService()
    
    private init() {}
    
    func loadCurrentWeather(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void
    ) {
        
        //let url = "https://openweathermap.org"
        //let url = Constants.weatherURL
        let url = "\(Constants.weatherURL)/weather"
        
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": Constants.apiKey,
            "units": WeatherSettings.unitsParameter,
            "lang": WeatherSettings.languageParameter
        ]
        
        AF.request(url, parameters: parameters)
            .validate() 
            .responseDecodable(of: CurrentWeatherResponse.self) { response in
                switch response.result {
                        case .success(let weather):
                            completion(.success(weather))
                        case .failure(let error):
                            // Выводим сырой ответ сервера, чтобы увидеть ошибку глазами
                            if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                                print("--- СЫРОЙ ОТВЕТ СЕРВЕРА ---")
                                print(jsonString)
                            }
                            
                            // Выводим детальную причину поломки декодера
                    if let data = response.data, let htmlString = String(data: data, encoding: .utf8) {
                        print("--- ВОТ ЧТО НА САМОМ ДЕЛЕ ПРИСЛАЛ СЕРВЕР ---")
                        print(htmlString.prefix(300)) // Напечатает первые 300 символов страницы
                    }
                            if case .responseSerializationFailed(let reason) = error,
                               case .decodingFailed(let decodingError) = reason {
                                print("❌ КРИТИЧЕСКАЯ ОШИБКА ДЕКОДИРОВАНИЯ: \(decodingError)")
                            }
                            
                            completion(.failure(error))
                        }
                    }
    }
    
    func loadForecast(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<ForecastResponse, Error>) -> Void // Добавлен атрибут @Sendable
    ) {
        let url = "https://api.openweathermap.org/data/2.5/forecast"
        
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": Constants.apiKey,
            "units": WeatherSettings.unitsParameter,
            "lang": WeatherSettings.languageParameter
        ]
        
        AF.request(url, parameters: parameters)
            .validate()
//            .responseDecodable(of: ForecastResponse.self) { response in
//                switch response.result {
//                case .success(let forecast):
//                    completion(.success(forecast))
//                case .failure(let error):
//                    print("❌ Ошибка прогноза Alamofire: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//            }
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let forecast = try JSONDecoder().decode(ForecastResponse.self, from: data)
                        completion(.success(forecast))
                    } catch {
                        completion(.failure(error))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

//    func loadForecast(
//        latitude: Double,
//        longitude: Double,
//        completion: @escaping @Sendable (Result<ForecastResponse, Error>) -> Void
//    ) {
//        // Использован правильный адрес API для прогноза
//        let url = "https://api.openweathermap.org/data/2.5/forecast"
//        
//        let parameters: [String: Any] = [
//            "lat": latitude,
//            "lon": longitude,
//            "appid": Constants.apiKey,
//            "units": WeatherSettings.unitsParameter,
//            "lang": WeatherSettings.languageParameter
//        ]
//        
//        AF.request(url, parameters: parameters)
//            .validate()
//            .responseDecodable(of: ForecastResponse.self) { response in
//                switch response.result {
//                case .success(let forecast):
//                    completion(.success(forecast))
//                case .failure(let error):
//                    print("❌ Ошибка прогноза Alamofire: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//            }
//    }
    
    
}


//import Foundation
//import Alamofire
//
//final class WeatherService {
//    static let shared = WeatherService()
//    
//    
//    private init() {}
//    
////    nonisolated func loadCurrentWeather(
////        latitude: Double,
////        longitude: Double,
////        completion: @escaping @Sendable (Result<CurrentWeatherResponse, Error>) -> Void
////    ) {
////        let url = "\(Constants.weatherURL)/weather"
////        
////        let parameters: [String: Any] = [
////            "lat": latitude,
////            "lon": longitude,
////            "appid": Constants.apiKey,
////            "units": "metric",
////            "lang": "ru"
////        ]
////        
////        AF.request(url, parameters: parameters)
////            .validate()
////            .responseDecodable(of: CurrentWeatherResponse.self) { response in
////                switch response.result {
////                    case .success(let weather):
////                        completion(.success(weather))
////                    
////                    case .failure(let error):
////                        print(error)
////                        completion(.failure(error))
////                }
////            }
////    }
//    
//    func loadCurrentWeather(
//            latitude: Double,
//            longitude: Double,
//            completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void
//        ) {
//            // 1. Указываем базовый URL вашего API
//            var components = URLComponents(string: "https://openweathermap.org")
//            
//            // 2. Динамически подставляем параметры, включая единицы измерения из UserDefaults
//            components?.queryItems = [
//                URLQueryItem(name: "lat", value: "\(latitude)"),
//                URLQueryItem(name: "lon", value: "\(longitude)"),
//                URLQueryItem(name: "appid", value: Constants.apiKey),
//                
//                // ДИНАМИЧЕСКИЙ ПАРАМЕТР: подставит "metric" или "imperial" автоматически
//                URLQueryItem(name: "units", value: WeatherSettings.unitsParameter),
//                URLQueryItem(name: "lang", value: WeatherSettings.languageParameter)
//            ]
//            
//            guard let url = components?.url else { return }
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                guard let data = data else { return }
//                
//                do {
//                    let weather = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
//                    completion(.success(weather))
//                } catch {
//                    completion(.failure(error))
//                }
//            }.resume()
//        }
//    
//    
//    
//    func loadForecast(
//        latitude: Double,
//        longitude: Double,
//        completion: @escaping(Result<ForecastResponse, Error>) -> Void
//    ) {
//
//        guard let url = URL(
//            string:
//                "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.apiKey)&units=metric&lang=ru"
//        ) else {
//
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//
//            if let error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data else {
//                return
//            }
//
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Ответ сервера: \(jsonString)")
//            }
//
//            do {
//
//                let forecast = try JSONDecoder().decode(
//                    ForecastResponse.self,
//                    from: data
//                )
//
//                completion(.success(forecast))
//
//            } catch let decodingError as DecodingError {
//                // Этот блок покажет точную причину ошибки в консоли Xcode
//                switch decodingError {
//                case .typeMismatch(let key, let value):
//                    print("❌ Ошибка типа данных: Ключ '\(key)' ожидал тип \(value.debugDescription)")
//                case .valueNotFound(let type, let context):
//                    print("❌ Значение не найдено для типа \(type) в контексте: \(context.debugDescription)")
//                case .keyNotFound(let key, let context):
//                    print("❌ Ключ '\(key.stringValue)' отсутствует в JSON. Контекст: \(context.debugDescription)")
//                case .dataCorrupted(let context):
//                    print("❌ Данные повреждены / Неверный JSON: \(context.debugDescription)")
//                @unknown default:
//                    print("❌ Неизвестная ошибка декодирования")
//                }
//                completion(.failure(decodingError))
//            } catch {
//
//                completion(.failure(error))
//            }
//
//        }.resume()
//    }
//
//
//    
//}
