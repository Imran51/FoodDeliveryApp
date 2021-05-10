//
//  FoodItemViewInteractor.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation
import RxSwift

class FoodItemViewInteractor: PresenterToFoodItemViewInteractor {
    var presenter: InteractorToFoodItemViewPresenter?
    
    private let service: NetworkManager
    let disposeBag = DisposeBag()
    
    init(service: NetworkManager = NetworkManager()) {
        self.service = service
    }
    
    func fetchFoodItemsData() {
        presenter?.isLoading(isLoading: true)
        service.fetchAllFoodItems()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] tasks in
                
                self?.presenter?.interactorDidFetchAllFoodItems(with: tasks)
                self?.presenter?.isLoading(isLoading: false)
            }) { [weak self] error in
                guard let errorValue = error as? APIError else { return }
                self?.presenter?.interactorDidFailFetch(with: errorValue.message)
                self?.presenter?.isLoading(isLoading: false)
            }.disposed(by: disposeBag)
    }
}
