//
//  FloatExtension.swift
//  SabbePay
//
//  Created by Romeu Godoi on 19/12/18.
//  Copyright © 2018 Logics Software. All rights reserved.
//

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }

    func toCurrency(symbol: Bool = true) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencySymbol = symbol ? "R$ " : ""
        formatter.alwaysShowsDecimalSeparator = true
        
        let formattedValue = formatter.string(from: NSNumber(value: self))
        
        return formattedValue
    }
}
