//
//  FoodItemContainerTableViewCell.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import UIKit
import SDWebImage
import SnapKit

protocol FoodItemContainerTableViewCellDelegate: AnyObject {
    func priceButtonClicked(withItemId itemId: Int, withPrice price: String)
}

class FoodItemContainerTableViewCell: UITableViewCell {
    static let identifier = "FoodItemContainerTableViewCell"
    
    weak var delegate: FoodItemContainerTableViewCellDelegate?
    
    private var priceButtonTapCounter = 0
    private var itemId: Int?
    
    struct ParentStackviewConstraintConstant {
        static let topInset = 10
        static let bottomInset = 10
        static let leadingInset = 32
        static let trailingInset = 32
        static let lowPriority = 999
    }
    
    struct ContainerViewConstraintConstant {
        static let lowPriority = 999
    }
    
    struct TitleImageConstraintConstant {
        static let height = 200
    }
    
    struct RightSidePriceButtonConstraintConstant {
        static let height = 50
        static let width = 100
    }
    
    struct EmptyStackViewConstraintConstantConstant {
        static let height = 10
    }
    
    private let titleImageView: UIImageView = {
        let image = CustomImageView()
        
        return image
    }()
    
    private let containerView: UIView = {
        let view = CardView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let parentStackview: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        return stack
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 5
        
        return stack
    }()
    
    private let subContainerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 5
        
        return stack
    }()
    
    private let subHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        
        return stack
    }()
    
    private let emptyStackview: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        return stack
    }()
    
    private let emptyFixedheightStackview: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        return stack
    }()
    
    private let titleTypeLabel: UILabel = {
        let label = addComponent.label(id: "label", type: .roboto_bold, text: "", size: 20, addColor: .black, align: .left)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = addComponent.label(id: "descriptionLabel", type: .roboto_regular, text: "", size: 16, addColor: .textGray, align: .left)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let bottomInfoLabel: UILabel = {
        let label = addComponent.label(id: "bottomInfoLabel", type: .roboto_regular, text: "", size: 16, addColor: .textGray, align: .left)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let rightSidePriceButton: UIButton = {
        let button = addComponent.buttonCustomFont(id: "rightSidePriceButton", title: "Price", corner: 25, bgColor: .black, textColor: .white, isBorder: false, fontSize: 16, type: .roboto_bold, borderColor: .clear)
        
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(parentStackview)
        
        parentStackview.addArrangedSubview(containerView)
        parentStackview.addArrangedSubview(emptyStackview)
        
        containerView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(titleImageView)
        containerStackView.addArrangedSubview(subContainerStackView)
        containerStackView.addArrangedSubview(emptyFixedheightStackview)
        
        subContainerStackView.addArrangedSubview(titleTypeLabel)
        subContainerStackView.addArrangedSubview(descriptionLabel)
        subContainerStackView.addArrangedSubview(subHorizontalStackView)
        
        subHorizontalStackView.addArrangedSubview(bottomInfoLabel)
        subHorizontalStackView.addArrangedSubview(rightSidePriceButton)
        
        setUpConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstaints(){
        parentStackview.snp.makeConstraints{
            make in
            make.top
                .equalToSuperview()
                .inset(ParentStackviewConstraintConstant.topInset)
            make.bottom
                .equalToSuperview()
                .inset(ParentStackviewConstraintConstant.bottomInset)
                .priority(ParentStackviewConstraintConstant.lowPriority)
            make.leading
                .equalToSuperview()
                .inset(ParentStackviewConstraintConstant.leadingInset)
            make.trailing
                .equalToSuperview()
                .inset(ParentStackviewConstraintConstant.trailingInset)
                .priority(ParentStackviewConstraintConstant.lowPriority)
        }
        
        containerView.snp.makeConstraints{
            make in
            make.top
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .priority(ContainerViewConstraintConstant.lowPriority)
            make.leading
                .equalToSuperview()
            make.trailing
                .equalToSuperview()
                .priority(ContainerViewConstraintConstant.lowPriority)
        }
        
        containerStackView.snp.makeConstraints{
            make in
            make.top
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .priority(ContainerViewConstraintConstant.lowPriority)
            make.leading
                .equalToSuperview()
            make.trailing
                .equalToSuperview()
                .priority(ContainerViewConstraintConstant.lowPriority)
        }
        
        titleImageView.snp.makeConstraints{
            make in
            make.height
                .equalTo(TitleImageConstraintConstant.height)
        }
        
        rightSidePriceButton.snp.makeConstraints{
            make in
            make.height
                .equalTo(RightSidePriceButtonConstraintConstant.height)
            make.width
                .equalTo(RightSidePriceButtonConstraintConstant.width)
        }
        
        emptyFixedheightStackview.snp.makeConstraints{
            make in
            make.height.equalTo(EmptyStackViewConstraintConstantConstant.height)
        }
        
        subContainerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        subContainerStackView.isLayoutMarginsRelativeArrangement = true
        
        rightSidePriceButton.addTarget(self, action: #selector(priceButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleImageView.image = nil
        titleTypeLabel.text = nil
        descriptionLabel.text = nil
        bottomInfoLabel.text = nil
        rightSidePriceButton.setTitle(nil, for: .normal)
        priceButtonTapCounter = 0
        itemId = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with data: FoodItemDetails, withImageUrl url: String, withItemId itemId: Int) {
        self.itemId = itemId
        titleImageView.sd_setImage(with: URL(string: url))
        titleTypeLabel.text = data.name
        descriptionLabel.text = data.description
        bottomInfoLabel.text = data.size
        rightSidePriceButton.setTitle(data.price, for: .normal)
    }
}

// MARK:- RightSideButton Click Action Implementation

extension FoodItemContainerTableViewCell {
    @objc private func priceButtonTapped(_ sender: UIButton){
        let oldButtonTitle = sender.currentTitle ?? ""
        priceButtonTapCounter += 1
        delegate?.priceButtonClicked(withItemId: itemId ?? 456666565, withPrice: oldButtonTitle)
        
        UIView.transition(
            with: rightSidePriceButton,
            duration: 1,
            options: .transitionFlipFromRight,
            animations: {
                [unowned self] in
                self.rightSidePriceButton.setTitle("added +\(self.priceButtonTapCounter)", for: .normal)
                self.rightSidePriceButton.backgroundColor = .green
            },
            completion: {
                [weak self] _ in
                UIView.transition(
                    with: self!.rightSidePriceButton,
                    duration: 1,
                    options: .transitionFlipFromLeft,
                    animations: {
                        self?.rightSidePriceButton.backgroundColor = .black
                        self?.rightSidePriceButton.setTitle(oldButtonTitle, for: .normal)
                    }
                )
            }
        )
    }
}
