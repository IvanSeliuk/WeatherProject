//
//  WeatherViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 25.03.22.
//

import UIKit
import Lottie
import GoogleMobileAds

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var showRequestsHistory: UIButton!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    private var rewardedAd: GADRewardedAd?
    var isRewarded = false
    var cityText: String?
    
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
        textFieldCity.text = nil
        okButton.isEnabled = false
        MediaManager.shared.clearSoundPlayer()
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("clouds")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    private func setupUI() {
        okButton.isEnabled = false
        okButton.layer.cornerRadius = 35
        okButton.setTitle("Search".localized, for: .normal)
        textFieldCity.delegate = self
        showRequestsHistory.setTitle("Show requests history".localized, for: .normal)
        showRequestsHistory.layer.cornerRadius = 20
    }
    
    private func enabledHistoryButton() {
        if CoreDataManager.shared.getSourceFromDB(by: SourceValue.map.rawValue).count > 0 || CoreDataManager.shared.getSourceFromDB(by: SourceValue.city.rawValue).count > 0 {
            showRequestsHistory.isEnabled = true
        } else {
            showRequestsHistory.isEnabled = false
        }
    }
    
    private func localized() {
        textFieldCity.placeholder = "textField.placeholder".localized
    }
    
    private func setupAction() {
        textFieldCity.addTarget(self, action: #selector(textFieldClick), for: .editingChanged)
    }
    
    @objc func textFieldClick() {
        okButton.isEnabled = textFieldCity.text?.count ?? 0 > 0
    }
    
    private func pushShowViewController() {
        guard let vc = ShowWeatherViewController.getInstanceController as? ShowWeatherViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        vc.cityGetWeather = cityText
    }
    
    //MARK: GoogleAds
    func loadRewardedAd() {
        view.showLoading()
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                view.closeLoading()
                pushShowViewController()
                AdvertisementInApp.shared.startTimer()
                return
            }
            view.closeLoading()
            ad?.present(fromRootViewController: self) {
                self.isRewarded = true
                print("Reward")
            }
            rewardedAd = ad
            print("Rewarded ad loaded.")
            rewardedAd?.fullScreenContentDelegate = self
        })
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

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Video Ads:
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
