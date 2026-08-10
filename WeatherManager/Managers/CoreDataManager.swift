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
    func saveWeather(from weather: CurrentWeatherResponse, latitude: Double, longitude: Double) -> Bool {
        
        if weatherExists(latitude: latitude, longitude: longitude) {
            return false
        }
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
        
        return true
        
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
    func deleteCity(_ city: CityWeather) {
        context.delete(city)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // проверка на дублирование (по координатам)
    func weatherExists(
        latitude: Double,
        longitude: Double
    ) -> Bool {

        

        let request: NSFetchRequest<CityWeather> =
        CityWeather.fetchRequest()

        request.predicate = NSPredicate(
            format: "latitude == %lf AND longitude == %lf",
            latitude,
            longitude
        )

        request.fetchLimit = 1

        do {
            return try context.count(for: request) > 0
        } catch {
            print("Ошибка проверки города: \(error)")
            return false
        }
    }

    
}
