//
//  WeatherViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 25.03.22.
//

import UIKit
import GoogleMobileAds
import Lottie

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var showRequestsHistory: UIButton!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    var rewardedAd: GADRewardedAd?
    var isRewarded = false
    var cityText: String?
    
    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        localized()
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAnimation()
        enabledHistoryButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupUIAfterDisappear()
        MediaManager.shared.clearSoundPlayer()
    }
    
    //MARK: - Action & push
    @objc func textFieldClick() {
        okButton.isEnabled = textFieldCity.text?.count ?? 0 > 0
    }
    
    func pushShowViewController() {
        guard let vc = ShowWeatherViewController.getInstanceController as? ShowWeatherViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        vc.cityGetWeather = cityText
    }
    
    @IBAction func showController(_ sender: Any) {
        AdvertisementInApp.shared.timerInterstitial?.invalidate()
        cityText = textFieldCity.text
        loadRewardedAd()
    }
    
    @IBAction func showRequestsHistoryAction(_ sender: Any) {
        guard let vc = ShowHistoryRequestViewController.getInstanceController else { return }
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.click.rawValue)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TableViewDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - GoodleAdsDelegate
extension WeatherViewController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        if isRewarded {
            isRewarded = false
            pushShowViewController()
            AdvertisementInApp.shared.startTimer()
        }
    }
}
