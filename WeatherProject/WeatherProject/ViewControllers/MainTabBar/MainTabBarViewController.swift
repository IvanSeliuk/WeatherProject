//
//  MainTabBarViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 25.03.22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocalized()
    }
    
    private func setupTabBar() {
        navigationController?.navigationBar.isHidden = true
        UITabBar.appearance().tintColor = UIColor.yellow
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        
       
        if RCManager.shared.string(forKey: .mapType) == MapType.apple.rawValue {
            if let mapVC = MapViewController.getInstanceController {
                viewControllers?.append(mapVC)
            }
        } else {
            if let googleVC = GoogleMapViewController.getInstanceController {
                viewControllers?.append(googleVC)
            }
        }
        if RCManager.shared.bool(forKey: .showNews) {
            if let newsVC = NewsViewController.getInstanceController {
                viewControllers?.append(newsVC)
            }
        }
    }
    
    private func setupLocalized() {
        let localized = ["tabBarItem.weather", "tabBarItem.map", "tabBarItem.news"]
        tabBar.items?.enumerated().forEach({ index, item in
            item.title = localized[index].localized
        })
    }
}
