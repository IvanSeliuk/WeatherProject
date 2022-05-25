//
//  FileServiceManager.swift
//  WeatherProject
//
//  Created by Иван Селюк on 22.03.22.
//

import Foundation
import UIKit

class FileServiceManager {
    static let shared = FileServiceManager()
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
    
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func getImage(from stringUrl: String, completed: @escaping (UIImage?) -> ()) {
        let pathImage = stringUrl.replacingOccurrences(of: "https://", with: "")
        let imageUrl = documentDirectory.appendingPathComponent(pathImage)
        if !directoryExistsAtPath(imageUrl.deletingLastPathComponent().path) {
            do {
                try FileManager.default.createDirectory(atPath: imageUrl.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
            } catch (let e) {
                print(e.localizedDescription)
            }
        }
        guard let dataImage = FileManager.default.contents(atPath: imageUrl.path)
        else {
            DispatchQueue.global().async {
                guard let url = URL(string: stringUrl) else { return }
                
                if let newDataImage = try? Data(contentsOf: url) {
                    do {
                        try newDataImage.write(to: imageUrl)
                        DispatchQueue.main.async {
                            completed(UIImage(data: newDataImage))
                        }
                    } catch (let e) {
                        print(e.localizedDescription)
                    }
                }
            }
            return
        }
        DispatchQueue.main.async {
            completed(UIImage(data: dataImage))
        }
        
        
    }
    
    
}
