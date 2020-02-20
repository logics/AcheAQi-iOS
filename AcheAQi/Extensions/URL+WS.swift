//
//  URL+WS.swift
//  Logics 
//
//  Created by Romeu Godoi on 06/04/17.
//  Copyright © 2017 Oconcurs. All rights reserved.
//

import Foundation

extension URL {
    init(wsURLWithPath path: String) {
        self = URL(string: Constants.baseAPIURL + "/" + path)!
    }
}

