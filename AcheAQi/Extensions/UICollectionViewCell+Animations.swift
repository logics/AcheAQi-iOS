//
//  UICollectionViewCell+Animations.swift
//  Testie
//
//  Created by Romeu Godoi on 18/08/17.
//  Copyright © 2017 Logics Tecnologia e Serviços. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    func animatePop(completionHandler: ((_ finished: Bool) -> ())?) {
        
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: completionHandler)
    }
}
