//
//  FoodItemViewPresenter.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation

class FoodItemViewPresenter: FoodItemViewToPresenter {
    
    var router: PresenterToFoodItemViewRouter?
    
    var interactor: PresenterToFoodItemViewInteractor?
    
    var view: PresenterToFoodItemView?
    
    private var originalFoodItems = [FoodItem]()
    
    func fetchFoodItemsData() {
        interactor?.fetchFoodItemsData()
    }
    
    func fetchFoodItemsData(for foodTypes: FoodTypes) {
        view?.updateSegmenteViewAndTableView(with: filterFoodList(for: foodTypes))
    }
    
    func fetchFoodItemsData(for foodTypes: FoodTypes, withOriginalFoodItems foodItems: [FoodItem]) {
        originalFoodItems = foodItems
        view?.updateSegmenteViewAndTableView(with: filterFoodList(for: foodTypes))
    }
}

extension FoodItemViewPresenter: InteractorToFoodItemViewPresenter {
    func interactorDidFetchAllFoodItems(with foodItems: FoodItemsResponse?){
        guard let items = foodItems?.items else { return }
        originalFoodItems = items
        view?.updateSegmenteViewAndTableView(with: filterFoodList(for: .Pizza))
    }
    
    func interactorDidFailFetch(with error: String){
        view?.update(with: error)
    }
    
    func isLoading(isLoading: Bool){
        view?.isLoading(isLoading: isLoading)
    }
}

extension FoodItemViewPresenter {
    private func filterFoodList(for foodType: FoodTypes) -> [FoodItem] {
        let filteredList = originalFoodItems.filter{
            $0.title.lowercased() == foodType.rawValue.lowercased()
        }
        
        return filteredList
    }
}
