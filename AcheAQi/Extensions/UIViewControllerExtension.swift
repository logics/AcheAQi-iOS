//
//  UIViewControllerExtension.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 16/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    var closeButton: UIButton! {
        let btn = UIButton(frame: CGRect(x: 15, y: 30, width: 40, height: 40))
        
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.setTitle("", for: .normal)
        btn.tintColor = UIColor(named: "secondaryFont")
        btn.tag = 2020
        btn.translatesAutoresizingMaskIntoConstraints = true
        
        btn.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        return btn
    }
    
    func addCloseButton() {
        if view.viewWithTag(2020) != closeButton {
            view.addSubview(closeButton)
        }
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
