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

            switch contentMode {
            case .scaleAspectFit: contentLayer.contentsGravity = .resizeAspect
            case .scaleToFill: contentLayer.contentsGravity = .resize
            case .scaleAspectFill: contentLayer.contentsGravity = .resizeAspectFill
            case .bottom: contentLayer.contentsGravity = .bottom
            case .bottomLeft: contentLayer.contentsGravity = .bottomLeft
            case .bottomRight: contentLayer.contentsGravity = .bottomRight
            case .center: contentLayer.contentsGravity = .center
            case .left: contentLayer.contentsGravity = .left
            case .redraw: contentLayer.contentsGravity = .resize
            case .right: contentLayer.contentsGravity = .right
            case .top: contentLayer.contentsGravity = .top
            case .topLeft: contentLayer.contentsGravity = .topLeft
            case .topRight: contentLayer.contentsGravity = .topRight
            default:
                break
            }
            
            insertSublayer(contentLayer, at: 0)
        }
    }
}
