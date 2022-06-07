//
//  AdvertisementInApp.swift
//  WeatherProject
//
//  Created by Иван Селюк on 17.05.22.
//

import Foundation
import GoogleMobileAds

class AdvertisementInApp: NSObject {
    static let shared = AdvertisementInApp()
    
    var timerInterstitial: Timer?
    private var interstitial: GADInterstitialAd?
    
    func startTimer() {
        timerInterstitial = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: false, block: { _ in
            self.loadInterstitial()
        })
    }
    
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
            guard let controller = UIApplication.shared.topViewController() else { return }
            interstitial?.present(fromRootViewController: controller)
        })
    }
}

extension AdvertisementInApp: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        timerInterstitial?.invalidate()
        startTimer()
        print("Ad did fail to present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        timerInterstitial?.invalidate()
        startTimer()
        print("Ad did dismiss full screen content.")
    }
}
