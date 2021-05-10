//
//  HomeViewRouter.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation

class HomeViewRouter: PresenterToRouter {
    var entry: EntryPoint?
    
    static func start() -> PresenterToRouter {
        let router = HomeViewRouter()
        // Assign VIP
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
}
