//
//  NetworkService.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Moya

enum NetworkService {
    case discounts
    case foodItems
}

extension NetworkService: TargetType {
    var baseURL: URL {
        return URL(string: "https://60976741e48ec00017872882.mockapi.io/api/v1/food_delivery")!
    }
    
    var path: String {
        switch self {
        case .discounts:
            return "/discounts_scheme"
        case .foodItems:
            return "/foodItems"
        }
    }
    
    var method: Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}
