//
//  BaseFonts.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation
public enum BaseFonts {
    case roboto_regular, roboto_bold, roboto_medium, roboto_light, lato_bold, lato_medium, lato_light
    
    public var customFont: String{
        switch self {
        case .roboto_bold:
            return "Roboto-Bold"
        case .roboto_medium:
            return "Roboto-Medium"
        case .roboto_light:
            return "Roboto-Light"
        case .lato_bold:
            return "Lato-Bold"
        case .lato_medium:
            return "Lato-Medium"
        case .lato_light:
            return "Lato-Light"
        default:
            return "Roboto-Regular"
        }
    }
}
