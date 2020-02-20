//
//  String+CpfCnpj.swift
//  SabbePay
//
//  Created by Romeu Godoi on 03/01/19.
//  Copyright © 2019 Logics Software. All rights reserved.
//

import Foundation

extension String {
    func cpfObfuscated() -> String {
        let firstDigit = String(self[..<String.Index(utf16Offset: 3, in: self)])
        let lastDigit = String(self[String.Index(utf16Offset: 3, in: self)])
        let cpf = String(format: "%@.%@**.***-**", firstDigit, lastDigit)

        return cpf
    }
    
    func cnpjObfuscated() -> String {
        let first = self.prefix(2).description
        let last = self.suffix(2).description
        let cnpj = String(format: "%@.***.***/****-%@", first, last)
        
        return cnpj
    }
}
