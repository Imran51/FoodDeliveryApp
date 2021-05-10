//
//  SildingCollectionViewCell.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import UIKit
import SnapKit

class SildingCollectionViewCell: UICollectionViewCell {
    static let identifier = "SildingCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleToFill
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
//        contentView.layer.cornerRadius = 6.0
//        contentView.layer.borderWidth = 1.5
//        contentView.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints{
            make in
            make.top.edges.equalTo(contentView)
        }
    }
    
    func configure(with resourceName: String) {
        imageView.image = UIImage(named: resourceName)
        contentView.backgroundColor = .green
    }
    
}
