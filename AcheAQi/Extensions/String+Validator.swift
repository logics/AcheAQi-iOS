//
//  String+Validator.swift
//  Logics
//
//  Created by Romeu Godoi on 17/06/17.
//  Copyright © 2017 Oconcurs. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidLogin() -> Bool {
        return 5...15 ~= self.count
    }
}
