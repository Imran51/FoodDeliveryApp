//
//  BaseColor.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation
import UIKit

public enum BaseColor {
    case appPrimary, appPrimaryDarker, textGray, lineGray, white, black, clear, red, yellow, transparentBlack
    
    var color : UIColor {
        switch self {
        case .appPrimary:
            return UIColor(rgb: 0x733572)
        case .appPrimaryDarker:
            return UIColor(red: 0.41, green: 0.19, blue: 0.4, alpha: 1.0)
        case .textGray:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.54)
        case .lineGray:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.08)
        case .transparentBlack:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        case .white:
            return UIColor.white
        case .black:
            return UIColor.black
        case .clear:
            return UIColor.clear
        case .red:
            return UIColor.red
        case .yellow:
            return UIColor.yellow
        }
    }
}
