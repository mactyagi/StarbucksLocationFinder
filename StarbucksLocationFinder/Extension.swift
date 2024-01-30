//
//  Extension.swift
//  StarbucksLocationFinder
//
//  Created by Manu on 30/01/24.
//

import Foundation

extension Double{
    func formatDistance() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

