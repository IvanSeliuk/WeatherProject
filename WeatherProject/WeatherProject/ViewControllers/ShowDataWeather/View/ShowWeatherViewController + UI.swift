//
//  ShowWeatherViewController + UI.swift
//  WeatherProject
//
//  Created by Иван Селюк on 4.06.22.
//

import NVActivityIndicatorView

extension ShowWeatherViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
    }
    
    func getDataWeather() {
        guard let cityGetWeather = cityGetWeather else { return }
        NetworkServiceManager.shared.getWeather(with: cityGetWeather) { [weak self] weatherData in
            guard let self = self else { return }
            CoreDataManager.shared.addWeatherToBaseData(by: weatherData, source: SourceValue.city.rawValue, date: Date())
            self.menu = weatherData
            MediaManager.shared.playVideoPlayer(with: CurrentWeatherVideo.setVideosBackground(by: self.menu?.weather.first?.icon ?? ""),
                                                view: self.videoView)
            self.activityIndicatorCustom.stopAnimating()
        } onError: { [weak self] error in
            guard let error = error else { return }
            self?.activityIndicatorCustom.stopAnimating()
            self?.showAlert(with: error)
            MediaManager.shared.playSoundPlayer(with: SoundsChoice.alar.rawValue)
        }
    }
}
