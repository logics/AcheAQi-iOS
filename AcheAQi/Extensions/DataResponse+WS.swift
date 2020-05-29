//
//  DataResponse+WS.swift
//  Oconcurs
//
//  Created by Romeu Godoi on 21/06/17.
//  Copyright © 2017 Oconcurs. All rights reserved.
//

import Foundation
import Alamofire

extension DataResponse {
    
    public var errorMessage: String?  {
        
        if let data = self.data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    return message
                }
                else if let errorMsg = json?["error"] as? String {
                    return errorMsg
                }
                else if let errorMsg = json?["errors"] as? [String] {
                    return errorMsg.first
                }
            } catch {
                return error.localizedDescription
            }
        }
        
        return nil
    }
    
    public var currentPage: Int? {
        guard let page = response?.allHeaderFields["x-current-page"] as? String else {
            return nil
        }
        
        return Int(page)
    }
    
    public var itemsPerPage: Int? {
        guard let items = response?.allHeaderFields["x-items-per-page"] as? String else {
            return nil
        }
        
        return Int(items)
    }
    
    public var lastPage: Int? {
        guard let page = response?.allHeaderFields["x-last-page"] as? String else {
            return nil
        }
        
        return Int(page)
    }

    public var totalCount: Int? {
        guard let count = response?.allHeaderFields["x-total-count"] as? String else {
            return nil
        }
        
        return Int(count)
    }
}
