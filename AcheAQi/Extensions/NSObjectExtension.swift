//
//  NSObjectExtension.swift
//  Logics
//
//  Created by Romeu Godoi on 14/12/18.
//  Copyright © 2018 Logics Software. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
