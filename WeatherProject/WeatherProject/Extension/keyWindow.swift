//
//  keyWindow.swift
//  WeatherProject
//
//  Created by Иван Селюк on 31.05.22.
//

import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
    }
}
