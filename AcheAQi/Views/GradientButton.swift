//
//  GradientButton.swift
//  Testie
//
//  Created by Romeu Godoi on 25/12/17.
//  Copyright © 2017 Logics Tecnologia e Serviços. All rights reserved.
//

import UIKit

@IBDesignable class GradientButton: UIButton {
    
    private var shapeLayer = CAShapeLayer()
    private var bgColor: UIColor?
    private var gradient = CAGradientLayer()
    
    @IBInspectable
    override var backgroundColor: UIColor? {
        get {
            return UIColor.clear
        }
        set(newValue) {
            super.backgroundColor = UIColor.clear
            self.bgColor = newValue
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isBgGradientColor: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
            if cornerRadius > 0.0  {
                isOpaque = false
                clipsToBounds = true
            }
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
    
    @IBInspectable
    var cornerTopLeft: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerBottomLeft: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerTopRight: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerBottomRight: Bool = true {
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
    var gradientHorizontal: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    func getCorners() -> UIRectCorner {
        var rectCorner: UIRectCorner = UIRectCorner()
        
        if self.cornerTopLeft {
            rectCorner.insert(.topLeft)
        }
        if self.cornerBottomLeft {
            rectCorner.insert(.bottomLeft)
        }
        if self.cornerTopRight {
            rectCorner.insert(.topRight)
        }
        if self.cornerBottomRight {
            rectCorner.insert(.bottomRight)
        }
        
        return rectCorner
    }
    
    private func makeCornerRadius() -> Void {
        
        shapeLayer.removeFromSuperlayer()
        
        if cornerRadius > 0 {
            
            let maskPath = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: self.getCorners(),
                                        cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
            
            shapeLayer.path = maskPath.cgPath
            shapeLayer.frame       = self.bounds
            shapeLayer.lineWidth   = self.borderWidth
            shapeLayer.strokeColor = self.borderColor.cgColor
            shapeLayer.fillColor   = self.bgColor?.cgColor
            self.layer.insertSublayer(shapeLayer, at: 0)
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
            
            self.gradient.startPoint = self.gradientHorizontal ? GradientPoint.leftRight.draw().x : GradientPoint.topBottom.draw().x
            self.gradient.endPoint = self.gradientHorizontal ? GradientPoint.leftRight.draw().y : GradientPoint.topBottom.draw().y
            
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.makeCornerRadius()
        self.makeBgGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradient.frame = self.bounds
    }
}

