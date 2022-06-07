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
    
    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.start2.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupConnectRemoteConfig()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MediaManager.shared.clearSoundPlayer()
    }
}

