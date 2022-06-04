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
    
    var menu: Welcome? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Life cicle VC
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
        pushPopViewController()
        MediaManager.shared.clearSoundPlayer()
        MediaManager.shared.clearVideoPlayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Push
    private func pushPopViewController() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDelegate
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
                cell.setupWeatherCell(with: menu)
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
