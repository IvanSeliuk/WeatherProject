//
//  NetworkServiceManager.swift
//  WeatherProject
//
//  Created by Иван Селюк on 22.03.22.
//

import Foundation
import UIKit
import Alamofire

class NetworkServiceManager {
    let session = URLSession.shared
    static let shared = NetworkServiceManager()
    
    func getWeather(with city: String,
                    onCompletion: @escaping (Welcome) -> (),
                    onError: ((String?) -> ())?) {
        
        guard let url = API.city.getCity(by: city) else { return }
        AF.request(url).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let welcome):
                DispatchQueue.main.async {
                    onCompletion(welcome)
                }
            case .failure(let error):
                onError?(error.localizedDescription + "\nCity not found".localized)
            }
        }
    }
    
    func getWeatherCoordCity(lat: Double,
                             lon: Double,
                    onCompletion: @escaping (Welcome) -> (),
                    onError: ((String?) -> ())?) {
        
        guard let url = API.coordinate.getCoordinate(by: lat, lon: lon) else { return }
        AF.request(url).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let welcome):
                DispatchQueue.main.async {
                    onCompletion(welcome)
                }
            case .failure(let error):
                onError?(error.localizedDescription + "\nCity not found".localized)
            } 
        }
    }
    
    func getNews(onCompletion: @escaping (News) -> (),
                 onError: ((String?) -> ())?) {
        
        guard let url = API.hostNews.url else { return }
        AF.request(url).responseDecodable(of: News.self) { response in
            switch response.result {
            case .success(let news):
                DispatchQueue.main.async {
                    onCompletion(news)
                }
            case .failure(let error):
                onError?(error.localizedDescription)
            }
        }
    }
}
