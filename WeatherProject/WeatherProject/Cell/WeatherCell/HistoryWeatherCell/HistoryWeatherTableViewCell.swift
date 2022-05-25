//
//  HistoryWeatherTableViewCell.swift
//  WeatherProject
//
//  Created by Иван Селюк on 18.04.22.
//

import UIKit
import Lottie

class HistoryWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var containerActions: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    var dateRequest: Date?
    var userClickRemoveRowInMap: (() -> ())?
    
    lazy var dateFormatted: DateFormatter = {
        let dateFormatted = DateFormatter()
        dateFormatted.locale = Locale(identifier: "en_ENG")
        dateFormatted.dateFormat = "d MMM yyyy, HH:mm:ss"
        return dateFormatted
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        panGesture.delegate = self
        containerView.addGestureRecognizer(panGesture)
        setupAnimation()
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
                if self.containerView.frame.origin.x < -self.containerActions.bounds.width {
                    self.containerView.frame.origin.x = -self.containerActions.bounds.width
                } else {
                    if self.containerView.frame.origin.x > 0 {
                        self.containerView.frame.origin.x = 0
                    } else {
                        if abs(self.containerView.frame.origin.x) > (self.containerActions.bounds.width / 2) {
                            self.containerView.frame.origin.x = -self.containerActions.bounds.width
                        } else  {
                            self.containerView.frame.origin.x = 0
                        }
                    }
                }
            }
        default: break
        }
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("remove9")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @IBAction func removeRowAction(_ sender: Any) {
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.delete.rawValue)
        CoreDataManager.shared.removeRowFromDB(by: dateRequest ?? Date())
        userClickRemoveRowInMap?()
    }
    
    func setupParametresWithMap(with parametres: WeatherDate) {
        cityLabel.text = "Weather".localized + "\(parametres.welcome.name), " + "\(parametres.welcome.sys.country)"
        temperatureLabel.text = "\(parametres.welcome.main.temp.celsius)ºC"
        longitudeLabel.text = "\(parametres.welcome.coord.lon)"
        latitudeLabel.text = "\(parametres.welcome.coord.lat)"
        dateLabel.text = dateFormatted.string(from: parametres.date)
        dateRequest = parametres.date
    }
   
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
