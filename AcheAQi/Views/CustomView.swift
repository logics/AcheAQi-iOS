//
//  CustomView.swift
//  Logics
//
//  Created by Romeu Godoi on 02/01/17.
//  Copyright © 2017 Logics Tecnologia e Serviços. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
        
    let containerView = UIView()
    private var shapeLayer = CAShapeLayer()
    private var bgColor: UIColor?
    private var gradient = CAGradientLayer()
    
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

    override var backgroundColor: UIColor? {
        didSet {
            self.bgColor = self.backgroundColor
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
//            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
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
    
    @IBInspectable
    var isBgGradientColor: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var startColor: UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var midColor: UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var endColor: UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var bgHorizontalGradient: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private func makeBgGradient() -> Void {
        
        self.gradient.removeFromSuperlayer()
        
        if startColor != UIColor.clear || midColor != UIColor.clear || endColor != UIColor.clear {
            
            self.gradient.frame = self.bounds
            
            var colors = [CGColor]()
            
            colors.append(startColor.cgColor)
            if midColor != UIColor.clear { colors.append(midColor.cgColor) }
            colors.append(endColor.cgColor)
            
            self.gradient.colors = colors
            
            self.gradient.endPoint = self.bgHorizontalGradient ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 0.5, y: 1)
            
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.makeBgGradient()
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
    
    let cornerLayer = CAShapeLayer()
    
    func layoutView() {
        
        // set the cornerRadius of the containerView's layer
        var maskedCorners = CACornerMask()
        var corners = UIRectCorner()
        
        if cornerTL {
            corners.insert(.topLeft)
            maskedCorners.insert(.layerMinXMinYCorner)
        }
        if cornerTR {
            corners.insert(.topRight)
            maskedCorners.insert(.layerMaxXMinYCorner)
        }
        if cornerBL {
            corners.insert(.bottomLeft)
            maskedCorners.insert(.layerMinXMaxYCorner)
        }
        if cornerBR {
            corners.insert(.bottomRight)
            maskedCorners.insert(.layerMaxXMaxYCorner)
        }
                
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
//        cornerLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
//        cornerLayer.fillColor = UIColor.clear.cgColor
//        cornerLayer.shadowPath = cornerLayer.path
//        cornerLayer.shadowColor = layer.shadowColor
//        cornerLayer.shadowOffset = layer.shadowOffset
//        cornerLayer.shadowOpacity = layer.shadowOpacity
//        cornerLayer.shadowRadius = layer.shadowRadius
//
//        layer.shadowPath = cornerLayer.path
//        layer.cornerRadius = cornerRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.maskedCorners = maskedCorners
//        layer.addShadowIfNeeded(width: maskedCorners, cornerRadius: cornerRadius)

//        layer.sublayers?.filter{ $0.frame.equalTo(self.bounds) }
//        .forEach{
//            $0.cornerRadius = self.cornerRadius
//            $0.maskedCorners = maskedCorners
//        }
        
        
//        cornerLayer.removeFromSuperlayer()
//        layer.addSublayer(cornerLayer)


//        roundCorners(corners: corners, radius: cornerRadius)
        
//        containerView.backgroundColor = backgroundColor
//        containerView.layer.masksToBounds = true
//        containerView.layer.shadowRadius = layer.shadowRadius
//        containerView.layer.shadowOffset = layer.shadowOffset
//        containerView.layer.shadowOpacity = layer.shadowOpacity
//        containerView.layer.shadowColor = layer.shadowColor
//        containerView.layer.shadowPath = layer.shadowPath
//        containerView.layer.borderColor = borderColor.cgColor
//        containerView.layer.borderWidth = borderWidth
//
//        containerView.removeFromSuperview()
//        // addSubview(containerView)
//        insertSubview(containerView, at: 0)
//        
//        //
//        // add additional views to the containerView here
//        //
//        
//        // add constraints
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // pin the containerView to the edges to the view
//        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    private var shadowLayer: CAShapeLayer!
    private var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor

    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.shadowOffset = .zero
//        self.shadowOpacity = 0.2
//        self.shadowRadius = 10
//        self.shadowColor = UIColor.black.cgColor
//        self.masksToBounds = false
//        if cornerRadius != 0 {
//            addShadowWithRoundedCorners()
//        }
        
//        layer.addShadowIfNeeded(width: CACornerMask(), cornerRadius: cornerRadius)
        
//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//            shadowLayer.fillColor = fillColor.cgColor
//
//            shadowLayer.shadowColor = UIColor.black.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//            shadowLayer.shadowOpacity = 0.2
//            shadowLayer.shadowRadius = 3
//
//            layer.insertSublayer(shadowLayer, at: 0)
//        }
    }
}
