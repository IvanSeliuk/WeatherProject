//
//  GoogleMapViewController + UI.swift
//  WeatherProject
//
//  Created by Иван Селюк on 4.06.22.
//

import UIKit
import Lottie
import GoogleMaps
import CoreLocation
import GoogleMobileAds
import RxSwift

extension GoogleMapViewController {
    func allSetup() {
        setupManager()
        setupUI()
        setupAds()
        setupDispatchTimeInterval()
    }
    private func setupUI() {
        showView.alpha = 0
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.consumesGesturesInView = true
        mapView.settings.scrollGestures = true
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
    }
    
    func setupAnimation() {
        animationView.animation = Animation.named("map1")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    private func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupAds() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    private func setupDispatchTimeInterval() {
        subjectCoordinate
            .debounce(DispatchTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                self.getCoordCityData(lat: value.latitude, lon: value.longitude)
            }).disposed(by: disposeBag)
    }
    
    private func getCoordCityData(lat: Double, lon: Double) {
        NetworkServiceManager.shared.getWeatherCoordCity(lat: lat, lon: lon) { [weak self] weatherData in
            CoreDataManager.shared.addWeatherToBaseData(by: weatherData, source: SourceValue.map.rawValue, date: Date())
            self?.menu = weatherData
        } onError: { [weak self] error in
            guard let error = error else { return }
            self?.showAlert(with: error)
            MediaManager.shared.playSoundPlayer(with: SoundsChoice.alar.rawValue)
        }
    }
    
    func setupWeatherDate(with menu: Welcome) {
        cityLabel?.text = "Weather".localized + "\(menu.name), " + "\(menu.sys.country)"
        temperatureLabel?.text = "\(menu.main.temp.celsius)ºC"
        humidityLabel?.text = "Humidity".localized + "\(menu.main.humidity) %"
        pressureLabel?.text = "Pressure".localized + "\(menu.main.pressure) " + "hPa".localized
        tempMaxLabel?.text = "TemperatureMax".localized + "\(menu.main.tempMax.celsius) ºC"
        tempMinLabel?.text = "TemperatureMin".localized + "\(menu.main.tempMin.celsius) ºC"
        windLabel?.text = "Wind".localized + "\(menu.wind.speed) " + "m/s".localized
        visibilityLabel?.text = "Visibility".localized + "\(menu.visibility) " + "km".localized
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let posterUrl = API.icon.getIconUrl(by: menu.weather.first?.icon ?? ""),
               let data = try? Data(contentsOf: posterUrl, options: .alwaysMapped) {
                DispatchQueue.main.async {
                    self?.whatDayImage?.image = UIImage(data: data)
                }
            }
        }
    }
}
