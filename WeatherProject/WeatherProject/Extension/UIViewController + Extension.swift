//
//  UIStoryboard + CoreKit.swift
//  Lesson13
//
//  Created by Андрей Трофимов on 24.01.22.
//

import UIKit
import CDAlertView

extension UIViewController {
    static var getInstanceController: UIViewController? {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController()
    }
    static func getViewController(with identifier: String) -> UIViewController? {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func showAlert(with messageError: String) {
        let alert = CDAlertView(title: "Error", message: messageError, type: .error)
        let cancel = CDAlertViewAction(title: "OK! 🤔")
        alert.add(action: cancel)
        alert.show { [weak self] _ in
            MediaManager.shared.clearSoundPlayer()
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
