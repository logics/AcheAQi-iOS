//
//  AvatarView.swift
//  Logics
//
//  Created by Romeu Godoi on 26/11/16.
//  Copyright © 2016 Logics Tecnologia e Serviços. All rights reserved.
//

import UIKit
//import AlamofireImage

@IBDesignable
class AvatarView: UIView {
    
//    var user: Usuario? {
//        didSet {
//            if let path = user?.avatarPath {
////                imageView.af_setImage(withURL: URL(wsURLWithPath: path))
//            } else {
//                imageView.image = #imageLiteral(resourceName: "anonymous")
//            }
//        }
//    }
    
    @IBInspectable
    var avatar: UIImage? = UIImage(named: "anonymous") {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var avatarInset: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return borderWidth > 0 ? self.bounds.size.width / 2 : 0
        }
    }
    
    var isEffectApplied: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    func resetAvatar() {
        imageView.image = UIImage(named: "anonymous")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    lazy var imageView: UIImageView = {
        
        let originalSize = self.bounds.size
        var size = CGSize(width: (originalSize.width - ((self.borderWidth + self.avatarInset) * 2)),
                          height: (originalSize.height - ((self.borderWidth + self.avatarInset) * 2)))
        
        let xy = self.avatarInset > 0 ? self.borderWidth + self.avatarInset : self.borderWidth
        
        var imageView = UIImageView(frame: CGRect(origin: CGPoint(x: xy, y: xy), size: size))
        imageView.layer.cornerRadius = max(size.width, size.height)/2.0;
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        
        let margins = self.layoutMarginsGuide
        self.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        return imageView
    }()
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        

        self.clipsToBounds = true
        
        let image = self.imageView.image ?? self.avatar
        
        if (self.isEffectApplied) {
            let beginImage = CIImage(cgImage: image!.cgImage!);
            
            let filter = CIFilter(name: "CIPhotoEffectProcess", parameters: [kCIInputImageKey: beginImage])
            
            let outputImage = filter?.outputImage;
            self.imageView.image = UIImage(ciImage: outputImage!, scale: UIScreen.main.scale, orientation: .up)
        }
        else {
            self.imageView.image = image
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let originalSize = self.imageView.frame.size
        let size = CGSize(width: (originalSize.width - ((self.borderWidth + self.avatarInset) * 2)),
                          height: (originalSize.height - ((self.borderWidth + self.avatarInset) * 2)))
        
        self.imageView.layer.cornerRadius = max(size.width, size.height)/2.0;
    }
}
