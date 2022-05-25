//
//  RCManager.swift
//  WeatherProject
//
//  Created by Иван Селюк on 9.04.22.
//

import UIKit
import FirebaseRemoteConfig

enum ValueKey: String {
    case showNews
    case mapType
}
enum MapType: String {
    case apple
    case google
}

class RCManager {
    static let shared = RCManager()
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
        loadDefaultValue()
    }
    
    private func loadDefaultValue() {
        let defaultValue: [String : Any] = [
            ValueKey.mapType.rawValue: MapType.apple.rawValue,
            ValueKey.showNews.rawValue: true]
        
        remoteConfig.setDefaults(defaultValue as? [String : NSObject])
    }
    
    func connect(_ onCompleted: @escaping (() -> ())) {
        remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            if let error = error {
                print(error.localizedDescription)
                onCompleted()
                return
            }
            self.remoteConfig.activate { _, _ in
                onCompleted()
            }
        }
    }
    
    func string(forKey key: ValueKey) -> String? {
        return remoteConfig[key.rawValue].stringValue
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        return remoteConfig[key.rawValue].boolValue
    }
}
