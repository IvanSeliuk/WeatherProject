//
//  Localized.swift
//  WeatherProject
//
//  Created by Иван Селюк on 31.03.22.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localized", bundle: Bundle.main, comment: "")
    }
}
