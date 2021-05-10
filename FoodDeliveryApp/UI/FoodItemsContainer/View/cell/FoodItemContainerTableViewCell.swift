//
//  FoodItemContainerTableViewCell.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import UIKit
import SDWebImage
import SnapKit

class FoodItemContainerTableViewCell: UITableViewCell {
    static let identifier = "FoodItemContainerTableViewCell"
    
    private let titleImageView: UIImageView = {
        let image = CustomImageView()
        
        return image
    }()
    
    private let parentStackview: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        return stack
    }()
    
    private let containerView: UIView = {
        let view = CardView()
        view.backgroundColor = .white

        return view
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
        
        subContainerStackView.addArrangedSubview(titleTypeLabel)
        subContainerStackView.addArrangedSubview(descriptionLabel)
        
        subHorizontalStackView.addArrangedSubview(bottomInfoLabel)
        subHorizontalStackView.addArrangedSubview(rightSidePriceButton)
        
        subContainerStackView.addArrangedSubview(subHorizontalStackView)
        
        containerStackView.addArrangedSubview(subContainerStackView)
        containerStackView.addArrangedSubview(emptyFixedheightStackview)
        
        setUpConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstaints(){
        parentStackview.snp.makeConstraints{
            make in
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8).priority(999)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8).priority(999)
        }
        
        containerView.snp.makeConstraints{
            make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(999)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().priority(999)
        }
        
        containerStackView.snp.makeConstraints{
            make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(999)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().priority(999)
        }
        
        titleImageView.snp.makeConstraints{
            make in
            make.height.equalTo(200)
        }
        
        rightSidePriceButton.snp.makeConstraints{
            make in
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        emptyFixedheightStackview.snp.makeConstraints{
            make in
            make.height.equalTo(10)
        }
        
        subContainerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        subContainerStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleImageView.image = nil
        titleTypeLabel.text = nil
        descriptionLabel.text = nil
        bottomInfoLabel.text = nil
        rightSidePriceButton.setTitle(nil, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    func configure(with data: FoodItemDetails, withImageUrl url: String) {
        contentView.backgroundColor = .systemBackground
        titleImageView.sd_setImage(with: URL(string: url))
        
        titleTypeLabel.text = data.name
        descriptionLabel.text = data.description
        bottomInfoLabel.text = data.size
        rightSidePriceButton.setTitle(data.price, for: .normal)
    }
}
