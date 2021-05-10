//
//  NetworkManager.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import RxSwift
import Moya
import RxCocoa

protocol ApiService {
    func fetchDiscountImageResourceName() -> Single<DiscountImageResourceResponse?>
}

final class NetworkManager: ApiService {
    private let provider = MoyaProvider<NetworkService>(plugins: [NetworkLoggerPlugin()])
    
    func request<T: Codable>(networkService: NetworkService) -> Single<T?> {
        if !Reachability.isConnectedToNetwork() {
            return Single.error(APIError(with: .internetConnection, message: "No Internet Connection"))
        }
        
        return provider
            .rx.request(networkService)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1)))
            .catchError { error -> PrimitiveSequence<SingleTrait, Response> in
                return Single.error(APIError(with: .unknown, message: error.localizedDescription))
            }.flatMap {json -> Single<T?> in
                if json.statusCode >= 200 && json.statusCode <= 300 {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let response = try? decoder.decode(T.self, from: json.data) {
                        return Single.just(response)
                    }
                } else {
                    let error = APIError(with: .internalServerError, message: "Internal Server Error")
                    return Single.error(error)
                }
                let error = APIError(with: .unknown, message: "Failed to parse response")
                return Single.error(error)
            }
    }
    
    func fetchDiscountImageResourceName() -> Single<DiscountImageResourceResponse?> {
        return request(networkService: .discounts)
    }

    
}
