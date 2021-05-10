//
//  HomeViewPresenter.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation

class HomeViewPresenter: Presenter {
    var router: ViewRouter?
    
    var interactor: Interactor?{
        didSet{
            interactor?.getDiscountImageResouce()
        }
    }
    
    var view: HomeView?
    
    func interactorDidFailFetch(with error: String) {
        view?.update(with: error)
    }
    
    func interactorDidFetchAllFoodItems(with foodItems: FoodItemsResponse?){
        view?.update(with: foodItems)
    }
    
    func interactorDidFecthDiscountImageResouce(with result: DiscountImageResourceResponse?) {
        view?.update(with: result)
    }
    
    func isLoading(isLoading: Bool) {
        view?.isLoading(isLoading: isLoading)
    }
}
