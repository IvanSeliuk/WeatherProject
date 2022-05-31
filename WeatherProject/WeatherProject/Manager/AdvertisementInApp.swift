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

extension UIApplication {
    // function that lets you get topViewController of the app
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
//    let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .compactMap({$0 as? UIWindowScene})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
}
