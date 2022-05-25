//
//  Degrees.swift
//  WeatherProject
//
//  Created by Иван Селюк on 7.04.22.
//

import Foundation
extension Double {
    var celsius: Int {
        Int(Double(self) - 273.15)
    }
}
