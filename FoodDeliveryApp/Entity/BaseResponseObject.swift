//
//  BaseResponseObject.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation
import ObjectMapper

public class BaseResponseObject: NSObject, Mappable {

    public required init?(map: Map) {
    }

    override public init() {
        super.init()
    }

    public func mapping(map: Map) {
        // map implementation
    }
}
