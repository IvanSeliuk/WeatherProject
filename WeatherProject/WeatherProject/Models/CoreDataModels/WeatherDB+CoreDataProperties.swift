//
//  WeatherDB+CoreDataProperties.swift
//  
//
//  Created by Иван Селюк on 18.04.22.
//
//

import Foundation
import CoreData


extension WeatherDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDB> {
        return NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
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

}
