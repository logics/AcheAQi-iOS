//
//  MyButton.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 10/03/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

@available(iOS 9.0, *)
@IBDesignable
open class MyButton: UIControl {
    
    open var imageView: UIImageView!
    open var label: UILabel!
    
    private var imgHeightContraint: NSLayoutConstraint?
    private var viewsAlreadyAdded = false
    private var stackView = UIStackView() {
        didSet {
            self.stackView.axis = .vertical
            self.stackView.alignment = .center
            self.stackView.distribution = .fill
            self.stackView.spacing = 8
            self.stackView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBInspectable open var image: UIImage? {
        didSet {
            defaultSetup()
        }
    }
    
    @IBInspectable open var fontSize: CGFloat = 17.0 {
        didSet {
            defaultSetup()
        }
    }
    
    @IBInspectable open var title: String? {
        didSet {
            defaultSetup()
        }
    }
    
    @IBInspectable open var textColor: UIColor = .black {
        didSet {
            defaultSetup()
        }
    }
    
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            rippleLayer.elevation = elevation
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            rippleLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var shadowOffset: CGSize = .zero {
        didSet {
            rippleLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var roundingCorners: UIRectCorner = UIRectCorner.allCorners {
        didSet {
            rippleLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            rippleLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            rippleLayer.rippleScaleRatio = rippleScaleRatio
        }
    }
    @IBInspectable open var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            rippleLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable open var rippleEnabled: Bool = true {
        didSet {
            rippleLayer.rippleEnabled = rippleEnabled
        }
    }
    @IBInspectable open var rippleLayerColor: UIColor = .lightGray {
        didSet {
            rippleLayer.setRippleColor(color: rippleLayerColor)
        }
    }
    @IBInspectable open var backgroundAnimationEnabled: Bool = true {
        didSet {
            rippleLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            rippleLayer.superLayerDidResize()
        }
    }
    
    open lazy var rippleLayer: RippleLayer = RippleLayer(withView: self)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        defaultSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSetup()
    }
    
    private func defaultSetup() {
        let font = UIFont.systemFont(ofSize: self.fontSize)
        let image = self.image?.colored(self.tintColor)
        
        if let imageView = self.imageView {
            imageView.image = image
        }
        else {
            imageView = UIImageView(image: image)
        }
        
        if #available(iOS 13.0, *) {
            imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 27)
        } else {
            // Fallback on earlier versions
        }
        imageView.sizeToFit()
        
        if self.label == nil {
            self.label = UILabel()
        }
        
        label.font = font
        label.textColor = self.textColor
        label.text = title
        label.textAlignment = .center
        
        addViews()
        setupLayer()
    }
    
    public convenience init(icon: UIImage, title: String, font: UIFont? = nil, foregroundColor: UIColor, useOriginalImg: Bool = false, bgColor: UIColor = .white, cornerRadius: CGFloat = 0.0) {
        self.init()
        image = icon
        textColor = foregroundColor
        imageView = UIImageView(image: useOriginalImg ? icon : icon.colored(foregroundColor))
        label = UILabel()
        label.text = title
        label.textColor = foregroundColor
        label.textAlignment = .center
        if let font = font {
            label.font = font
        }
        self.cornerRadius = cornerRadius
        self.setCornerBorder(color: bgColor, cornerRadius: cornerRadius)
        self.backgroundColor = bgColor
        setupLayer()
        addViews()
        setNeedsLayout()
    }
    
    open func addViews() {
        if viewsAlreadyAdded == false {
            
            [label, imageView].forEach {
                self.stackView.addSubview($0.unsafelyUnwrapped)
                $0?.translatesAutoresizingMaskIntoConstraints = false
            }
            
            addSubview(stackView)
                        
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
            
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 8.0).isActive = true

            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 8.0).isActive = true

            setNeedsLayout()
            
            viewsAlreadyAdded = true
        }
    }
    
    fileprivate func setupLayer() {
        rippleLayer.elevation = self.elevation
        self.layer.cornerRadius = self.cornerRadius
        rippleLayer.elevationOffset = self.shadowOffset
        rippleLayer.roundingCorners = self.roundingCorners
        rippleLayer.maskEnabled = self.maskEnabled
        rippleLayer.rippleScaleRatio = self.rippleScaleRatio
        rippleLayer.rippleDuration = self.rippleDuration
        rippleLayer.rippleEnabled = self.rippleEnabled
        rippleLayer.backgroundAnimationEnabled = self.backgroundAnimationEnabled
        rippleLayer.setRippleColor(color: self.rippleLayerColor)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
//
//        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 8.0).isActive = true
//
//        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 8.0).isActive = true

        
//        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        
//        let width = self.frame.width
//        let height = self.frame.height
//        imageView.contentMode = .center
//
//        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.03*height).isActive = true
//        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.1*width).isActive = true
//        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.1*width).isActive = true
//        if imgHeightContraint != nil {
//            imgHeightContraint.unsafelyUnwrapped.isActive = false
//        }
//        imgHeightContraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
//        imgHeightContraint?.isActive = true
//
//        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0.05*height).isActive = true
//        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.1*width).isActive = true
//        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.1*width).isActive = true
//        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.03*height).isActive = true
        self.layoutIfNeeded()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        rippleLayer.touchesBegan(touches: touches, withEvent: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        rippleLayer.touchesEnded(touches: touches, withEvent: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        rippleLayer.touchesCancelled(touches: touches, withEvent: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        rippleLayer.touchesMoved(touches: touches, withEvent: event)
    }
}
