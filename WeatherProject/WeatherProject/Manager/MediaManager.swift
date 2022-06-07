//
//  MediaManager.swift
//  WeatherProject
//
//  Created by Иван Селюк on 26.04.22.
//

import AVFoundation
import UIKit

enum SoundsChoice: String {
    case delete,
         click,
         alar,
         begin,
         sms,
         list,
         start1,
         start2
}

enum FileFormat: String {
    case mp4, mp3
}

enum CurrentWeatherVideo: String {
    case Sunny1,
         SunnyCloudTop,
         Cloud,
         Cloud1,
         Rain,
         RainSlow,
         Shtorm,
         Snow,
         Moon,
         Mist
    
    static func setVideosBackground(by iconId: String) -> String {
        switch iconId {
        case "01d": return CurrentWeatherVideo.Sunny1.rawValue
        case "02d": return CurrentWeatherVideo.SunnyCloudTop.rawValue
        case "01n", "02n": return CurrentWeatherVideo.Moon.rawValue
        case "03d", "03n": return CurrentWeatherVideo.Cloud.rawValue
        case "04d", "04n": return CurrentWeatherVideo.Cloud1.rawValue
        case "09d", "09n": return CurrentWeatherVideo.Rain.rawValue
        case "10d", "10n": return CurrentWeatherVideo.RainSlow.rawValue
        case "11d", "11n": return CurrentWeatherVideo.Shtorm.rawValue
        case "13d", "13n": return CurrentWeatherVideo.Snow.rawValue
        case "50d", "50n": return CurrentWeatherVideo.Mist.rawValue
        default: return ""
        }
    }
}

class MediaManager {
    
    static let shared = MediaManager()
    var playerAudio: AVPlayer?
    var playerVideo: AVPlayer?
    var backgroundViewLayer: AVPlayerLayer?
    
    func playSoundPlayer(with name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: FileFormat.mp3.rawValue) else { return }
        let playerItam = AVPlayerItem(url: url)
        playerAudio = AVPlayer(playerItem: playerItam)
        playerAudio?.play()
    }
    
    func playVideoPlayer(with name: String, view: UIView) {
        guard let url = Bundle.main.url(forResource: name, withExtension: FileFormat.mp4.rawValue) else { return }
        let playerItem = AVPlayerItem(url: url)
        playerVideo = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerVideo?.currentItem)
        backgroundViewLayer = AVPlayerLayer(player: playerVideo)
        backgroundViewLayer?.frame = view.frame
        backgroundViewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(backgroundViewLayer!)
        playerVideo?.play()
    }
    
    @objc func videoDidEnd(_ notification: Notification) {
        playerVideo?.seek(to: .zero)
        playerVideo?.play()
    }
    
    func clearSoundPlayer() {
        playerAudio?.pause()
        playerAudio = nil
    }
    
    func clearVideoPlayer() {
        playerVideo?.pause()
        backgroundViewLayer?.removeFromSuperlayer()
        playerVideo = nil
        backgroundViewLayer = nil
    }
}
