//
//  HomeViewInteractor.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation
import RxSwift

class HomeViewInteractor: Interactor {
    var presenter: Presenter?
    
    private let service: NetworkManager
    let disposeBag = DisposeBag()
    
    init(service: NetworkManager = NetworkManager()) {
        self.service = service
    }
    
    func getDiscountImageResouce() {
        presenter?.isLoading(isLoading: true)
        Observable.zip(service.fetchDiscountImageResourceName().asObservable(),service.fetchAllFoodItems().asObservable()).subscribe(onNext: ({[weak self] (response) in
            let (discountImageResouceName,foodItems) = response
            self?.presenter?.interactorDidFecthDiscountImageResouce(with: discountImageResouceName)
            self?.presenter?.interactorDidFetchAllFoodItems(with: foodItems)
            self?.presenter?.isLoading(isLoading: false)
        }), onError: ({[weak self] (error) in
            guard let errorValue = error as? APIError else { return }
            self?.presenter?.interactorDidFailFetch(with: errorValue.message)
            self?.presenter?.isLoading(isLoading: false)
        })).disposed(by: disposeBag)
    }
    
    
}
