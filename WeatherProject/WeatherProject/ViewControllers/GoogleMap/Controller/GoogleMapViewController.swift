//
//  GoogleMapViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 8.04.22.
//

import UIKit
import Lottie
import GoogleMaps
import CoreLocation
import GoogleMobileAds
import RxSwift

class GoogleMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var whatDayImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let disposeBag = DisposeBag()
    let subjectCoordinate = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D())
    
    let locationManager = CLLocationManager()
    var menu: Welcome? {
        didSet {
            self.view.bringSubviewToFront(showView)
            guard let menu = self.menu else { return }
            self.setupWeatherDate(with: menu)
            MediaManager.shared.playSoundPlayer(with: SoundsChoice.sms.rawValue)
            MediaManager.shared.playVideoPlayer(with: CurrentWeatherVideo.setVideosBackground(by: menu.weather.first?.icon ?? ""), view: videoView)
            showView.layer.masksToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.showView.alpha = 1
            }
        }
    }
    
    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        allSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
        showView.alpha = 0
        MediaManager.shared.clearSoundPlayer()
        MediaManager.shared.clearVideoPlayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - GoogleMapViewDelegate
extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.showView.alpha = 0
        MediaManager.shared.clearSoundPlayer()
        MediaManager.shared.clearVideoPlayer()
        
        DispatchQueue.global().async {
            self.subjectCoordinate.onNext(position.target)
        }
    }
}

//MARK: - GoogleAdsDelegate
extension GoogleMapViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}
