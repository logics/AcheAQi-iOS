//
//  CALayer+Corners.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 20/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addShadowIfNeeded(width maskedCorners: CACornerMask, radius: CGFloat, contentMode: UIView.ContentMode = .scaleAspectFit, contentLayerName: String = "ContentLayer") {
        
        if let contents = self.contents {
            
            masksToBounds = false
            
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{
                    $0.cornerRadius = radius
                    $0.addShadowIfNeeded(width: maskedCorners, radius: radius, contentMode: contentMode)
            }
            
            self.contents = nil
            
            if let sublayer = sublayers?.first, sublayer.name == contentLayerName {
                sublayer.removeFromSuperlayer()
            }
            
            let contentLayer = CALayer()
            contentLayer.name = contentLayerName
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = radius
            contentLayer.maskedCorners = maskedCorners
            contentLayer.masksToBounds = true
            contentLayer.shouldRasterize = shouldRasterize
            contentLayer.rasterizationScale = UIScreen.main.scale
            contentLayer.contentsGravity = CALayer.contentsGravity(by: contentMode)
            
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    class func contentsGravity(by contentMode: UIView.ContentMode) -> CALayerContentsGravity {
        switch contentMode {
        case .scaleAspectFit:   return .resizeAspect
        case .scaleToFill:      return .resize
        case .scaleAspectFill:  return .resizeAspectFill
        case .bottom:           return .bottom
        case .bottomLeft:       return .bottomLeft
        case .bottomRight:      return .bottomRight
        case .center:           return .center
        case .left:             return .left
        case .redraw:           return .resize
        case .right:            return .right
        case .top:              return .top
        case .topLeft:          return .topLeft
        case .topRight:         return .topRight
        default:
            return .resizeAspect
        }
    }
}
