//
//  FoodItemsResponse.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation

public struct FoodItemsResponse: Codable {
    let items:[FoodItem]
}

public struct FoodItem: Codable {
    let id: Int
    let title: String
    let info:FoodItemDetails
    let imgUrl:String
}

public struct FoodItemDetails: Codable {
    let name:String
    let description: String
    let size: String
    let price: String
}
