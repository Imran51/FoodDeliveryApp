//
//  FoodItemContainerTableViewCell.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 10/5/21.
//

import UIKit

class FoodItemContainerTableViewCell: UITableViewCell {
    static let identifier = "FoodItemContainerTableViewCell"
    
    private let titleImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .quaternarySystemFill
        
        return view
    }()
    
    private let titleTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .bold)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let rightSidePriceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = button.frame.height/2
        button.layer.masksToBounds = true
        button.backgroundColor = .black
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(containerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = contentView.bounds
        titleImageView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height/2)
        titleTypeLabel.frame = CGRect(x: 0, y: titleImageView.frame.height+10, width: containerView.frame.width, height: 30)
        descriptionLabel.frame = CGRect(x: 0, y: titleImageView.frame.origin.y+10, width: containerView.frame.width, height: 50)
        bottomInfoLabel.frame = CGRect(x: 0, y: descriptionLabel.frame.origin.y+10, width: containerView.frame.width-60, height: 20)
        rightSidePriceButton.frame = CGRect(x: containerView.frame.width-60, y: descriptionLabel.frame.origin.y+10, width: containerView.frame.width, height: 20)
    }
    
//    func configure(with viewModel: TileCollectionViewCellViewModel) {
//        contentView.backgroundColor = viewModel.backgroundColor
//        label.text = viewModel.name
//    }
}
