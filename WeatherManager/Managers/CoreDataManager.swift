//
//  CoreDataManager.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {
        
    }
    
    var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer
            .viewContext
    }
    // сохранение
    func saveWeather(from weather: CurrentWeatherResponse, latitude: Double, longitude: Double) {
        let city = CityWeather(context: context)
        
        city.cityName = weather.name
        city.latitude = latitude
        city.longitude = longitude
        city.temperature = weather.main.temp
        city.humidity = Int16(weather.main.humidity)
        city.windSpeed = weather.wind.speed
        city.weatherDescription = weather.weather.first?.description
        city.icon = weather.weather.first?.icon
        city.lastUpdate = Date()
        
        do {
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // получение данных
    func fetchWeather() -> [CityWeather] {
        let request: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        
        do {
            return try context.fetch(request)
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    //удаление города
    func delete(_ city: CityWeather) {
        context.delete(city)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
