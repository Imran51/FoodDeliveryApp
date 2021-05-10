//
//  FoodItemViewRouter.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation
import FloatingPanel

class FoodItemViewRouter: PresenterToFoodItemViewRouter {
    static func createModule() -> FoodItemContainerViewController {
        let router = FoodItemViewRouter()
        // Assign VIP
        let view = FoodItemContainerViewController()
        var presenter: FoodItemViewToPresenter & InteractorToFoodItemViewPresenter = FoodItemViewPresenter()
        var interactor: PresenterToFoodItemViewInteractor = FoodItemViewInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func showFoodItemViewFloatingPanel(from viewController: UIViewController, withfloatingPanelView fpc : FloatingPanelController, with foodItems: [FoodItem]) {
        DispatchQueue.main.async {
            let foodItemViewController = FoodItemViewRouter.createModule()
            foodItemViewController.updateView(with: foodItems)
            fpc.view.isHidden = false
            fpc.set(contentViewController: foodItemViewController)
            
            fpc.delegate = viewController as? FloatingPanelControllerDelegate
            fpc.addPanel(toParent: viewController)
            fpc.contentMode = .fitToBounds
            
            let appearance = SurfaceAppearance()
            
            // Define shadows
            let shadow = SurfaceAppearance.Shadow()
            shadow.color = .gray
            shadow.offset = CGSize(width: 0, height: 16)
            shadow.radius = 16
            shadow.spread = 8
            appearance.shadows = [shadow]
            
            // Define corner radius and background color
            appearance.cornerRadius = 20
            appearance.backgroundColor = .white
            // Set the new appearance
            fpc.surfaceView.appearance = appearance
            
        }
    }
}
