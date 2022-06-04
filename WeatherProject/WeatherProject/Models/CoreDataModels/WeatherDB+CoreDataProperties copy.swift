//
//  WeatherDB+CoreDataProperties.swift
//  
//
//  Created by Иван Селюк on 17.04.22.
//
//

import Foundation
import CoreData


extension WeatherDB {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDB> {
        return NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
    }
    
    @nonobjc public class func fetchRequest(with source: String) -> NSFetchRequest<WeatherDB> {
        let request = NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
        request.predicate = NSPredicate(format: "source == %@", source)
        return request
    }
    
    @nonobjc public class func fetchRequestToDelete(with date: Date) -> NSFetchRequest<WeatherDB> {
        let request = NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        return request
    }
    
    @NSManaged public var country: String?
    @NSManaged public var date: Date?
    @NSManaged public var feelsLike: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var icon: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var pressure: Int64
    @NSManaged public var source: String?
    @NSManaged public var temp: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var tempMin: Double
    @NSManaged public var visibility: Int64
    @NSManaged public var windSpeed: Double
    
    func getMappedWeather() -> WeatherDate {
        return (Welcome(coord: Coord(lon: lon, lat: lat),
                       weather: [Weather(main: "", weatherDescription: "", icon: icon ?? "")],
                       main: Main(temp: temp,
                                  feelsLike: feelsLike,
                                  tempMin: tempMin,
                                  tempMax: tempMax,
                                  pressure: Int(pressure),
                                  humidity: Int(humidity)),
                       visibility: Int(visibility),
                       wind: Wind(speed: windSpeed),
                       sys: Sys(country: country ?? ""),
                       name: name ?? ""),
                getMappedData())
    }
    
    func getMappedData() -> Date {
        return date ?? Date()
    }
    
    func setValues(by weather: Welcome, source: SourceValue.RawValue, date: Date) {
        self.country = weather.sys.country
        self.feelsLike = weather.main.feelsLike
        self.humidity = Int64(weather.main.humidity)
        self.icon = weather.weather.first?.icon
        self.lat = weather.coord.lat
        self.lon = weather.coord.lon
        self.name = weather.name
        self.pressure = Int64(weather.main.pressure)
        self.source = source
        self.temp = weather.main.temp
        self.tempMax = weather.main.tempMax
        self.tempMin = weather.main.tempMin
        self.visibility = Int64(weather.visibility)
        self.windSpeed = weather.wind.speed
        self.date = date
    }
}
