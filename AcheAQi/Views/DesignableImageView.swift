//
//  DesignableImageView.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 20/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class DesignableImageView: UIImageView {
    
    @IBInspectable
    var cornerTL: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerTR: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerBL: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerBR: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        layoutView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layoutView()
    }
        
    func layoutView() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // set the cornerRadius of the containerView's layer
        var maskedCorners = CACornerMask()
        
        if cornerTL {
            maskedCorners.insert(.layerMinXMinYCorner)
        }
        if cornerTR {
            maskedCorners.insert(.layerMaxXMinYCorner)
        }
        if cornerBL {
            maskedCorners.insert(.layerMinXMaxYCorner)
        }
        if cornerBR {
            maskedCorners.insert(.layerMaxXMaxYCorner)
        }
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.maskedCorners = maskedCorners
        
        layer.addShadowIfNeeded(width: maskedCorners, radius: cornerRadius, contentMode: contentMode)
    }
}
