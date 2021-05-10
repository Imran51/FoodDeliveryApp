//
//  HomeProtocol.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation
import UIKit
import FloatingPanel

typealias EntryPoint = PresenterToHomeView & UIViewController

protocol PresenterToHomeView {
    var presenter: HomeViewToPresenter? { get set }
    
    func update(with discountImageName: DiscountImageResourceResponse?)
    
    func update(with foodItems: FoodItemsResponse?)
    
    func update(with error: String)
    
    func isLoading(isLoading: Bool)
}

protocol PresenterToRouter {
    var entry: EntryPoint? { get }
    
    static func start()  -> PresenterToRouter
    
    func showFloatingPanelView(from viewController: UIViewController, withFloatingPanel fpc: FloatingPanelController, withFoodItemsData foodItems: FoodItemsResponse?)
}

protocol HomeViewToPresenter {
    var router: PresenterToRouter? { get set }
    
    var interactor: PresenterToInteractor? { get set }
    
    var view: PresenterToHomeView? { get set }
    
    func fetchData()
    
    func showFloatingPanelView(from viewController: UIViewController, withFloatingPanel fpc: FloatingPanelController, withFoodItemsData foodItems: FoodItemsResponse?)
}



protocol PresenterToInteractor {
    var presenter: InteractorToPresenter? { get set }
    
    func fetchData()
}

protocol InteractorToPresenter {
    func interactorDidFecthDiscountImageResouce(with result: DiscountImageResourceResponse?)
    
    func interactorDidFetchAllFoodItems(with foodItems: FoodItemsResponse?)
    
    func interactorDidFailFetch(with error: String)
    
    func isLoading(isLoading: Bool)
}

