//
//  HomeViewRouter.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation
import FloatingPanel

class HomeViewRouter: PresenterToRouter {
    var entry: EntryPoint?
    
    static func start() -> PresenterToRouter {
        let router = HomeViewRouter()
        var view: PresenterToHomeView = HomeViewController()
        var presenter: HomeViewToPresenter & InteractorToPresenter = HomeViewPresenter()
        var interactor: PresenterToInteractor = HomeViewInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    func showFloatingPanelView(from viewController: UIViewController, withFloatingPanel fpc: FloatingPanelController, withFoodItemsData foodItems: FoodItemsResponse?) {
        let foodItemsViewRouter = FoodItemViewRouter()
        
        guard let items = foodItems?.items else {
            return
        }
        
        foodItemsViewRouter.showFoodItemViewFloatingPanel(from: viewController, withfloatingPanelView: fpc, with: items)
    }
}
