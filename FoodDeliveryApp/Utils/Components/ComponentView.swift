//
//  ComponentView.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import Foundation
import UIKit
import TTGSnackbar

public var addComponent: IComponentView {
    struct Singleton {
        static let instance = ComponentView()
    }
    return Singleton.instance
}

public protocol IComponentView {

    func label(id: String, type: BaseFonts, text: String, size: CGFloat, addColor: BaseColor, align: NSTextAlignment) -> UILabel
    
    func image(id: String, image: UIImage) -> UIImageView
    
    func view(addColor: BaseColor) -> UIView
    
    func buttonCustomFont(id: String, title: String, corner: CGFloat, bgColor: BaseColor, textColor: BaseColor, isBorder: Bool, fontSize: CGFloat, type: BaseFonts, borderColor: BaseColor) -> UIButton
    func tableView(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) -> UITableView
    
    func stackView(views: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView
    
    func showSnackBar(withMessage message: String, withType type: SnackBarType)
    
    func horizontalSpacerView() -> UIView
    
    func loadingActivityIndicator(isLoading: Bool)
}

public enum SnackBarType {
    case Error, Success, Ongoing
}

open class ComponentView: IComponentView {
    public func loadingActivityIndicator(isLoading: Bool) {
        isLoading ? CustomLoadingIndicatorView.sharedInstance.showBlurView(withTitle: "Please Wait...") : CustomLoadingIndicatorView.sharedInstance.hide()
    }
    
    public func horizontalSpacerView() -> UIView {
        let spacer = UIView()
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow
        
        return spacer
    }
    
    public func showSnackBar(withMessage message: String, withType type: SnackBarType) {
        let snackbar = TTGSnackbar(
            message: " ",
            duration: .middle,
            actionText: "Close",
            actionBlock: { (snackbar) in
                snackbar.dismiss()
            }
        )
        
        snackbar.cornerRadius = snackbar.frame.height/3
        snackbar.messageTextFont = UIFont.init(name: BaseFonts.roboto_bold.customFont, size: 18)!
        snackbar.actionTextFont = UIFont.init(name: BaseFonts.roboto_bold.customFont, size: 18)!
        snackbar.messageTextAlign = .center

        snackbar.message = message
        switch type {
        case .Error:
            snackbar.messageTextColor = .red
            snackbar.backgroundColor = .white
            snackbar.actionTextColor = .red
        case .Ongoing:
            snackbar.messageTextColor = .white
            snackbar.backgroundColor = .black
            snackbar.actionTextColor = .white
        default:
            snackbar.messageTextColor = .white
            snackbar.backgroundColor = .green
            snackbar.actionTextColor = .white
        }
        
        snackbar.show()
    }
    
    public func label(id: String, type: BaseFonts, text: String, size: CGFloat, addColor: BaseColor = .black, align: NSTextAlignment) -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = addColor.color
        label.accessibilityIdentifier = "label_identifier_\(id)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = align
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: type.customFont, size: size)
        label.text = text
        
        return label
    }
    
    public func image(id: String, image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "image_identifier_\(id)"
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
 
    
    public func view(addColor: BaseColor) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = addColor.color
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    public func buttonCustomFont(id: String, title: String, corner: CGFloat, bgColor: BaseColor, textColor: BaseColor, isBorder: Bool, fontSize: CGFloat, type: BaseFonts, borderColor: BaseColor) -> UIButton {
        let button: UIButton = UIButton()
        button.accessibilityIdentifier = "button_identifier_\(id)"
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: type.customFont, size: fontSize)
        button.layer.cornerRadius = corner
        button.addBackgroundColor(addColor: bgColor)
        button.setTitleColor(textColor.color, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        if isBorder {
            button.layer.borderColor = borderColor.color.cgColor
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1.0
        }
        
        return button
    }
    
    public func tableView(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) -> UITableView {
        let tableView: UITableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addBackgroundColor(addColor: .white)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        return tableView
    }
    
    public func stackView(views: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = .fill
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
}
