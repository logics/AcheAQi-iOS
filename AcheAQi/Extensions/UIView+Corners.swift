//
//  UIView+Corners.swift
//  Logics Software
//
//  Created by Romeu Godoi on 14/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        layer.mask = mask
    }
}
