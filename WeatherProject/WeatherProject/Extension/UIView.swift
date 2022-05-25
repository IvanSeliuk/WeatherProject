//
//  UIView.swift
//  Homework textField
//
//  Created by Иван Селюк on 24.01.22.
//

import UIKit

extension UIView {
    @IBInspectable var isNeedBorder: Bool {
        get {
            return false
        }
        
        set {
            layer.borderWidth = newValue ? 2 : 0
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            guard let color = layer.borderColor else {
                return .clear
            }
            
            return UIColor(cgColor: color)
        }
        
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
