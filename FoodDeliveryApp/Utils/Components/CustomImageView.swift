//
//  CustomImageView.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 11/5/21.
//

import Foundation
import UIKit

/*
    Note: This class is only created for rounding top-left & top-right corner of
    a imageview
 
 */
class CustomImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: 10)
    }
}
