//
//  UIButton+Extension.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 14/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

extension UIButton {
    func applyUnderline(for state: UIControl.State = .normal) {
        let attrs = [
            NSAttributedString.Key.underlineStyle : 1,
            NSAttributedString.Key.underlineColor : titleLabel!.textColor!,
            NSAttributedString.Key.font : titleLabel!.font!,
            NSAttributedString.Key.foregroundColor : titleLabel!.textColor!,
            
        ] as [NSAttributedString.Key : Any]
        
        let attrString = NSMutableAttributedString(string: currentTitle!, attributes: attrs)
        setAttributedTitle(attrString, for: .normal)
    }
}
