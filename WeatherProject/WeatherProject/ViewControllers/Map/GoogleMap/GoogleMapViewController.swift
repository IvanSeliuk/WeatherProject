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
    private var menu: Welcome? {
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupManager()
        setupUI()
        setupAds()
        dispatchTimeInterval()
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
    
    private func setupAnimation() {
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
    
    private func dispatchTimeInterval() {
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
    
    private func setupWeatherDate(with menu: Welcome) {
        cityLabel?.text = "Weather".localized + "\(menu.name), " + "\(menu.sys.country)"
        temperatureLabel?.text = "\(menu.main.temp.celsius)ºC"
        humidityLabel?.text = "Humidity".localized + "\(menu.main.humidity) %"
        pressureLabel?.text = "Pressure".localized + "\(menu.main.pressure) hPa"
        tempMaxLabel?.text = "TemperatureMax".localized + "\(menu.main.tempMax.celsius) ºC"
        tempMinLabel?.text = "TemperatureMin".localized + "\(menu.main.tempMin.celsius) ºC"
        windLabel?.text = "Wind".localized + "\(menu.wind.speed) m/s"
        visibilityLabel?.text = "Visibility".localized + "\(menu.visibility) km"
        
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

