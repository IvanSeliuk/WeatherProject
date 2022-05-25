//
//  ShowWeatherViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 22.03.22.
//

import UIKit
import NVActivityIndicatorView

enum SourceValue: String {
    case map, city
}

class ShowWeatherViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorCustom: NVActivityIndicatorView!
    @IBOutlet weak var videoView: UIView!
    var cityGetWeather: String?
    
    private var menu: Welcome? {
        didSet {
            tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getDataWeather()
        activityIndicatorCustom.startAnimating()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.sms.rawValue)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
        MediaManager.shared.clearSoundPlayer()
        MediaManager.shared.clearVideoPlayer()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
    }
    
    private func getDataWeather() {
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

extension ShowWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
            if let menu = menu {
                cell.setup(with: menu)
                //MediaManager.shared.playSoundPlayer(with: SoundsChoice.sms.rawValue)
            }
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}

extension ShowWeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 218.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
