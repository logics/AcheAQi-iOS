//
//  UIApplicationExtension.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 19/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func currentViewController() -> UIViewController? {
        
        let window = UIApplication.shared.windows.first
        
        if var vc = window?.rootViewController {
            while let presentedViewController = vc.presentedViewController {
                vc = presentedViewController
            }
            return vc
        }
        
        return window?.rootViewController
    }
    
    func resignCurrentResponder() {
        sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
