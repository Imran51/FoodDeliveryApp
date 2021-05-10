//
//  HomeProtocol.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation
import UIKit

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
}

protocol HomeViewToPresenter {
    var router: PresenterToRouter? { get set }
    
    var interactor: PresenterToInteractor? { get set }
    
    var view: PresenterToHomeView? { get set }
    
    func fetchData()
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

//protocol ViewToPresenterProtocol: class {
//    var view: PresenterToViewProtocol? {get set}
//    var interactor: PresenterToInteractorProtocol? {get set}
//    var router: PresenterToRouterProtocol? {get set}
//    func fetchingHome()
//    
//}
//
//protocol PresenterToViewProtocol: class{
//    func showDiscountImageResouceName(data: [DiscountImageResourceResponse]?)
//    func showError(error: String)
//}
//
//protocol PresenterToRouterProtocol: class {
//    static func createModule()-> ViewController
////    func showMovieController(navigationController:UINavigationController, menuEnum: HomeEnumSection)
////    func showMovieController(navigationController:UINavigationController, genres: MovieGenresModel?)
////    func showDetailMovieController(navigationController: UINavigationController, movie: UpcomingMoviesModel?)
//}
//
//protocol PresenterToInteractorProtocol: class {
//    //var presenter:InteractorToPresenterProtocol? {get set}
//    func fetchingHome()
//}
