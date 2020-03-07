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
        var urlPath = path
        
        if path.length > 0, path.prefix(1) != "/" {
            urlPath = "/" + path
        }
        
        self = URL(string: Constants.baseAPIURL + urlPath)!
    }
}

