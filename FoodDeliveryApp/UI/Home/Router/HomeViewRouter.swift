//
//  HomeViewRouter.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation

class HomeViewRouter: ViewRouter {
    var entry: EntryPoint?
    
    static func start() -> ViewRouter {
        let router = HomeViewRouter()
        // Assign VIP
        var view: HomeView = HomeViewController()
        var presenter: Presenter = HomeViewPresenter()
        var interactor: Interactor = HomeViewInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
