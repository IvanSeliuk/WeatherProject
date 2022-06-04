//
//  MapViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 25.03.22.
//

import UIKit
import MapKit
import Lottie
import GoogleMobileAds
import CoreLocation
import RxSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
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
    var subjectCoordinate: BehaviorSubject<CLLocationCoordinate2D>? = nil
    
    let locationManager = CLLocationManager()
    var menu: Welcome? {
        didSet {
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
        allSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationEnabled()
        showView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
        MediaManager.shared.clearSoundPlayer()
        MediaManager.shared.clearVideoPlayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Action
    @IBAction func myLocationAction(_ sender: Any) {
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.click.rawValue)
        guard let myLocation = locationManager.location?.coordinate else { return }
        mapView.setCenter(myLocation, animated: true)
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.click.rawValue)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        annotation.title = menu?.name
        annotation.subtitle = "Temperature: \(menu?.main.temp.celsius ?? 0)ºC"
        mapView.addAnnotation(annotation)
    }
}

//MARK: - MapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.showView.alpha = 0
        MediaManager.shared.clearSoundPlayer()
        MediaManager.shared.clearVideoPlayer()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let coordinates = CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            if self.subjectCoordinate == nil {
                self.subjectCoordinate = BehaviorSubject<CLLocationCoordinate2D>(value: coordinates)
                self.dispatchTimeInterval()
            } else {
                self.subjectCoordinate?.onNext(coordinates)
            }
        }
    }
}

//MARK: - GoogleAdsDelegate
extension MapViewController: GADBannerViewDelegate {
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
