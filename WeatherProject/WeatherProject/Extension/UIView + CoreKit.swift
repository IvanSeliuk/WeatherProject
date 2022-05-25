//
//  UIView + CoreKit.swift
//  WeatherProject
//
//  Created by Иван Селюк on 17.05.22.
//

import Foundation
import UIKit
extension UIView {
    func showLoading() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 242424
        blurEffectView.alpha = 0
        addSubview(blurEffectView)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.center
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.1) {
            blurEffectView.alpha = 1.0
        }
    }
    
    func closeLoading() {
        let blur = subviews.first(where: { $0.tag == 242424 })
        UIView.animate(withDuration: 0.1) {
            blur?.alpha = 0
        } completion: { _ in
            (blur?.subviews.first(where: { ($0 as? UIActivityIndicatorView) != nil }) as? UIActivityIndicatorView)?.stopAnimating()
            blur?.removeFromSuperview()
        }
    }
}
