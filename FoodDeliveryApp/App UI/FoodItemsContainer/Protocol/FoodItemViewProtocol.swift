//
//  FoodItemViewProtocol.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation
import FloatingPanel

protocol PresenterToFoodItemView {
    var presenter: FoodItemViewToPresenter? { get set }
    
    func updateSegmenteViewAndTableView(with filteredFoodItems: [FoodItem])
    
    func update(with error: String)
    
    func isLoading(isLoading: Bool)
}

protocol PresenterToFoodItemViewRouter {
    
    static func createModule() -> FoodItemContainerViewController
    
    func showFoodItemViewFloatingPanel(from viewController: UIViewController, withfloatingPanelView fpc : FloatingPanelController, with foodItems: [FoodItem])
}

protocol FoodItemViewToPresenter {
    var router: PresenterToFoodItemViewRouter? { get set }
    
    var interactor: PresenterToFoodItemViewInteractor? { get set }
    
    var view: PresenterToFoodItemView? { get set }
    
    func fetchFoodItemsData()
    
    func fetchFoodItemsData(for foodTypes: FoodTypes, withOriginalFoodItems foodItems: [FoodItem])
    
    func fetchFoodItemsData(for foodTypes: FoodTypes)
}

protocol PresenterToFoodItemViewInteractor {
    var presenter: InteractorToFoodItemViewPresenter? { get set }
    
    func fetchFoodItemsData()
}

protocol InteractorToFoodItemViewPresenter {
    func interactorDidFetchAllFoodItems(with foodItems: FoodItemsResponse?)
    
    func interactorDidFailFetch(with error: String)
    
    func isLoading(isLoading: Bool)
}
