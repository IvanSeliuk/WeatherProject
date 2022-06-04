//
//  NewsViewController + UI.swift
//  WeatherProject
//
//  Created by Иван Селюк on 4.06.22.
//

import UIKit

extension NewsViewController {
    func getDataNews() {
        NetworkServiceManager.shared.getNews { [weak self] dataNews in
            self?.news = dataNews
            self?.activityIndicator.stopAnimating()
        } onError: { [weak self] error in
            guard let error = error else { return }
            self?.activityIndicator.stopAnimating()
            self?.showAlert(with: error)
            MediaManager.shared.playSoundPlayer(with: SoundsChoice.alar.rawValue)
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
}
