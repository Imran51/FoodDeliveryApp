//
//  BadgeButton.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 11/5/21.
//

import UIKit

class BadgeButton : UIButton {
    
    var badgeValue : String! = "" {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override init(frame :CGRect)  {
        // Initialize the UIView
        super.init(frame : frame)
        
        self.awakeFromNib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.awakeFromNib()
    }
    
    
    override func awakeFromNib()
    {
        self.drawBadgeLayer()
    }
    
    var badgeLayer :CAShapeLayer!
    func drawBadgeLayer() {
        
        if self.badgeLayer != nil {
            self.badgeLayer.removeFromSuperlayer()
        }
        
        // Omit layer if text is nil
        if self.badgeValue == nil || self.badgeValue.count == 0 {
            return
        }
        
        //! Initial label text layer
        let labelText = CATextLayer()
        labelText.contentsScale = UIScreen.main.scale
        labelText.string = self.badgeValue.uppercased()
        labelText.fontSize = 12
        labelText.font = UIFont.init(name: BaseFonts.roboto_regular.customFont, size: 12)
        labelText.alignmentMode = CATextLayerAlignmentMode.center
        labelText.foregroundColor = UIColor.white.cgColor
        //let labelString = self.badgeValue.uppercased()
        let labelFont = UIFont.init(name: BaseFonts.roboto_regular.customFont, size: 12)
        //let attributes = [NSAttributedString.Key.font : labelFont]
        let w = self.frame.size.width
        let h = CGFloat(18.0)  // fixed height
        //let labelWidth = min(w * 0.8, 10.0)    // Starting point
//        _ = labelString.boundingRect(with: CGSize(width: labelWidth, height: h), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        labelText.frame = CGRect(x: 0, y: 0, width: 18, height: h)
        
        //! Initialize outline, set frame and color
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        let frame : CGRect = labelText.frame
        let cornerRadius = CGFloat(9.0)
        let borderInset = CGFloat(-1.0)
        let aPath = UIBezierPath(roundedRect: frame.insetBy(dx: borderInset, dy: borderInset), cornerRadius: cornerRadius)
        
        shapeLayer.path = aPath.cgPath
        shapeLayer.fillColor = UIColor.green.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 0.6
        
        shapeLayer.insertSublayer(labelText, at: 0)
        
        shapeLayer.frame = shapeLayer.frame.offsetBy(dx: w*0.6, dy: 0.0)
        
        self.layer.insertSublayer(shapeLayer, at: 999)
        self.layer.masksToBounds = false
        self.badgeLayer = shapeLayer
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawBadgeLayer()
        self.setNeedsDisplay()
    }
    
}
