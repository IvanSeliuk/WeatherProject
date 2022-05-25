//
//  LoadingViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 1.04.22.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet var viewLoading: UIView!
    @IBOutlet weak var worldGifImage: UIImageView!
    
    var images: [UIImage] = []
    
    lazy var animationDuration = {
        return Double(images.count) / 30.0
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.start2.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RCManager.shared.connect { [weak self] in
            DispatchQueue.main.async {
                self?.setAnimation()
                self?.startAnimation()
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MediaManager.shared.clearSoundPlayer()
    }
    
    private func setAnimation() {
        for i in 1...88 {
            if let image = UIImage(named: "\(i)") {
                images.append(image)
            }
        }
        worldGifImage.animationImages = images
        worldGifImage.animationRepeatCount = 1
        worldGifImage.animationDuration = animationDuration
    }
    
    private func startAnimation() {
        UIView.animateKeyframes(withDuration: animationDuration + 1, delay: 0, options: [.calculationModeLinear]) {
            self.worldGifImage.startAnimating()
            
            UIView.addKeyframe(withRelativeStartTime: 0.26, relativeDuration: 0.1) {
                self.viewLoading.backgroundColor = UIColor(named: "ColorGif")
            }
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1) {
                self.worldGifImage.image = self.images.last
            }
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.8) {
                self.viewLoading.alpha = 0
            }
        }
    completion: { _ in
        guard let mainTabBarViewController = MainTabBarViewController.getInstanceController else { return }
        self.navigationController?.viewControllers = [mainTabBarViewController]
        }
    }
}
