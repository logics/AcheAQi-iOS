//
//  DictionaryExtension.swift
//  SabbePay
//
//  Created by Romeu Godoi on 11/12/18.
//  Copyright © 2018 Logics Software. All rights reserved.
//

import Foundation

extension Dictionary {
    func toJsonString(prettify: Bool = false) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: prettify ? .prettyPrinted : JSONSerialization.WritingOptions())  else { return nil }
        let str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return String(str ?? "")
    }
}
