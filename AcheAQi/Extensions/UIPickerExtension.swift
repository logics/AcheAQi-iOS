//
//  UIPickerExtension.swift
//  QuadrasNet
//
//  Created by Romeu Godoi on 21/01/19.
//  Copyright © 2019 Logics Software. All rights reserved.
//

import UIKit

extension UIToolbar {
    
    class func toolbarPicker(target: Any?, action mySelect: Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.plain, target: target, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
