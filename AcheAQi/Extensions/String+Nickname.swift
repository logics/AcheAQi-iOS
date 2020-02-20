//
//  String+Nickname.swift
//  Testie
//
//  Created by Romeu Godoi on 20/04/18.
//  Copyright © 2018 Logics Tecnologia e Serviços. All rights reserved.
//

import Foundation

extension String {
    static let nicknameValidSet = "ABCDEFGHIJKLMNOPQRSTUVW‌​XYZabcdefghijklmnopq‌​rstuvwxyz0123456789.‌​_"
    
    func validNickname() -> String {
        
        if let stringAsciiData = self.data(using: .ascii, allowLossyConversion: true), var stringValida = String(data: stringAsciiData, encoding: .utf8) {
            
            let validSet = CharacterSet(charactersIn: String.nicknameValidSet)
            let setToRemove = validSet.inverted
            
            stringValida = stringValida.trimmingCharacters(in: setToRemove)
            
            return stringValida.lowercased()
        }
        
        return self.lowercased()
    }
}
