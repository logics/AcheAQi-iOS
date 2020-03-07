//
//  UIColor+Convenience.swift
//  Logics
//
//  Created by Romeu Godoi on 11/12/18.
//  Copyright © 2018 Logics Software. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(withLiteralRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    convenience init(hexString: String) {
        
        let hexString = (hexString as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner   = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.currentIndex = String.Index(utf16Offset: 1, in: hexString)
        }
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
