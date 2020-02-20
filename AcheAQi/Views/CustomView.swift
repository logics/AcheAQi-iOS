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
    var bgHorizontalGradient = false {
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
    }
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layoutView()
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        containerView.removeFromSuperview()
        //        addSubview(containerView)
        insertSubview(containerView, at: 0)
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

