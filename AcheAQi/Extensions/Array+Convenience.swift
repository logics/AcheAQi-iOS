//
//  Array+Convenience.swift
//  Aser RMS
//
//  Created by Romeu Godoi on 30/08/17.
//  Copyright © 2017 Aser Security. All rights reserved.
//

import Foundation

extension Array {
    func toJsonString(prettify: Bool = false) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: prettify ? .prettyPrinted : JSONSerialization.WritingOptions())  else { return nil }
        let str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return String(str ?? "")
    }
}
