//
//  UIView+Animations.swift
//  Logics Software
//
//  Created by Romeu Godoi on 21/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

extension UIView {
    
    func animatePop(completionHandler: ((_ finished: Bool) -> ())?) {
        
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: completionHandler)
    }
}
