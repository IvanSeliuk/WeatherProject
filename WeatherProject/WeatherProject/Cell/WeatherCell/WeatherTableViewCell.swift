//
//  WeatherTableViewCell.swift
//  WeatherProject
//
//  Created by Иван Селюк on 22.03.22.
//

import UIKit
import Lottie

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var whatDayImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var otherInformationLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerAction: UIView!
    @IBOutlet weak var animationView: AnimationView!
    var dateRequest: Date?
    var userClickRemoveRowInCity: (() -> ())?
    
    lazy var dateFormatted: DateFormatter = {
        let dateFormatted = DateFormatter()
        dateFormatted.locale = Locale(identifier: "en_ENG")
        dateFormatted.dateFormat = "d MMM yyyy \nHH:mm:ss"
        return dateFormatted
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPanGestureRecognizer()
        setupAnimation()
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("remove12")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func setupWeatherCell(with menu: Welcome) {
        cityLabel.text = "Weather".localized + "\(menu.name), " + "\(menu.sys.country)"
        temperatureLabel.text = "\(menu.main.temp.celsius)ºC"
        humidityLabel.text = "Humidity".localized + "\(menu.main.humidity) %"
        pressureLabel.text = "Pressure".localized + "\(menu.main.pressure) hPa"
        tempMaxLabel.text = "TemperatureMax".localized + "\(menu.main.tempMax.celsius) ºC"
        tempMinLabel.text = "TemperatureMin".localized + "\(menu.main.tempMin.celsius) ºC"
        otherInformationLabel.text = "FeelsLike".localized + "\(menu.main.feelsLike.celsius) ºC"
        windLabel.text = "Wind".localized + "\(menu.wind.speed) m/s"
        visibilityLabel.text = "Visibility".localized + "\(menu.visibility) km"
        dateLabel.text = dateFormatted.string(from: Date())
        
        DispatchQueue.global().async { [weak self] in
            if let posterUrl = API.icon.getIconUrl(by: menu.weather.first?.icon ?? ""),
               let data = try? Data(contentsOf: posterUrl, options: .alwaysMapped) {
                DispatchQueue.main.async {
                    self?.whatDayImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    func setupParametresWithCity(with parametres: (welcome: Welcome, date: Date)) {
        cityLabel.text = "Weather".localized + "\(parametres.welcome.name), " + "\(parametres.welcome.sys.country)"
        temperatureLabel.text = "\(parametres.welcome.main.temp.celsius)ºC"
        dateLabel.text = dateFormatted.string(from: parametres.date)
        humidityLabel.text = "Humidity".localized + "\(parametres.welcome.main.humidity) %"
        pressureLabel.text = "Pressure".localized + "\(parametres.welcome.main.pressure) hPa"
        tempMaxLabel.text = "TemperatureMax".localized + "\(parametres.welcome.main.tempMax.celsius) ºC"
        tempMinLabel.text = "TemperatureMin".localized + "\(parametres.welcome.main.tempMin.celsius) ºC"
        otherInformationLabel.text = "FeelsLike".localized + "\(parametres.welcome.main.feelsLike.celsius) ºC"
        windLabel.text = "Wind".localized + "\(parametres.welcome.wind.speed) m/s"
        visibilityLabel.text = "Visibility".localized + "\(parametres.welcome.visibility) km"
        dateRequest = parametres.date
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let posterUrl = API.icon.getIconUrl(by: parametres.welcome.weather.first?.icon ?? ""),
               let data = try? Data(contentsOf: posterUrl, options: .alwaysMapped) {
                DispatchQueue.main.async {
                    self?.whatDayImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func removeRowAction(_ sender: Any) {
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.delete.rawValue)
        CoreDataManager.shared.removeRowFromDB(by: dateRequest ?? Date())
        userClickRemoveRowInCity?()
    }
}

//MARK: - PanGestureRecognizer
extension WeatherTableViewCell {
    private func setupPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        panGesture.delegate = self
        containerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func panGestureAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began: break
        case .changed:
            let translation = sender.translation(in: containerView)
            sender.setTranslation(.zero, in: containerView)
            guard translation.x < 0 || containerView.frame.origin.x < 0 else { return }
            containerView.frame.origin.x += translation.x
        case .cancelled, .ended, .failed:
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                if self.containerView.frame.origin.x < -self.containerAction.bounds.width {
                    self.containerView.frame.origin.x = -self.containerAction.bounds.width
                } else {
                    if self.containerView.frame.origin.x > 0 {
                        self.containerView.frame.origin.x = 0
                    } else {
                        if abs(self.containerView.frame.origin.x) > (self.containerAction.bounds.width / 2) {
                            self.containerView.frame.origin.x = -self.containerAction.bounds.width
                        } else  {
                            self.containerView.frame.origin.x = 0
                        }
                    }
                }
            }
        default: break
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
