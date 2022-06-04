//
//  WeatherViewController + UI.swift
//  WeatherProject
//
//  Created by Иван Селюк on 4.06.22.
//
import Lottie
import UIKit
import GoogleMobileAds

extension WeatherViewController {
    //MARK: - SetupUI
    func setupUI() {
        okButton.isEnabled = false
        okButton.layer.cornerRadius = 35
        okButton.setTitle("Search".localized, for: .normal)
        textFieldCity.delegate = self
        showRequestsHistory.setTitle("Show requests history".localized, for: .normal)
        showRequestsHistory.layer.cornerRadius = 20
    }
    
    func enabledHistoryButton() {
        if CoreDataManager.shared.getSourceFromDB(by: SourceValue.map.rawValue).count > 0 || CoreDataManager.shared.getSourceFromDB(by: SourceValue.city.rawValue).count > 0 {
            showRequestsHistory.isEnabled = true
        } else {
            showRequestsHistory.isEnabled = false
        }
    }
    
    func localized() {
        textFieldCity.placeholder = "textField.placeholder".localized
    }
    
    func setupAnimation() {
        animationView.animation = Animation.named("clouds")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func setupUIAfterDisappear() {
        textFieldCity.text = nil
        okButton.isEnabled = false
    }
    
    func setupAction() {
        textFieldCity.addTarget(self, action: #selector(textFieldClick), for: .editingChanged)
    }
    
    //MARK: - GoogleAds
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
}
