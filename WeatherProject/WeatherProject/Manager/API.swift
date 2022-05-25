//
//  API.swift
//  WeatherProject
//
//  Created by Иван Селюк on 22.03.22.
//

import Foundation

enum API: String {
    case APIKey = "9872cf2db2b7f253bfd07c00eb5c255d"
    case host = "https://api.openweathermap.org/"
    case city = "data/2.5/weather?q=%@&appid=%@"
    case icon = "https://openweathermap.org/img/wn/%@@2x.png"
    case coordinate = "data/2.5/weather?lat=%.3f&lon=%.3f&appid=%@"
    
    case APIKeyNews = "08837f9a89a948bea5eb4ee9ab0f0ba8"
    case hostNews = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey="

    var url: URL? {
        return URL(string: API.hostNews.rawValue + API.APIKeyNews.rawValue)
    }
    
    func getCity(by name: String) -> URL? {
        let completedString = String(format: API.city.rawValue, name, API.APIKey.rawValue)
        return URL(string: API.host.rawValue + completedString)
    }
    
    func getIconUrl(by icon: String) -> URL? {
        let completedString = String(format: API.icon.rawValue, icon)
        return URL(string: completedString)
    }
    
    func getCoordinate(by lat: Double, lon: Double) -> URL? {
        let completedString = String(format: API.coordinate.rawValue, lat, lon, API.APIKey.rawValue)
        return URL(string: API.host.rawValue + completedString)
    }
}

