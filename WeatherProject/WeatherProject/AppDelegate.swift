//
//  AppDelegate.swift
//  WeatherProject
//
//  Created by Иван Селюк on 22.03.22.
//

import UIKit
import AlamofireNetworkActivityLogger
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import GoogleMobileAds
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        IQKeyboardManager.shared.enable = true
        AdvertisementInApp.shared.startTimer()
        
        GMSServices.provideAPIKey("AIzaSyCQEaPdTfKtamlStLkzxB4b7uFsK9TYhoA")
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

