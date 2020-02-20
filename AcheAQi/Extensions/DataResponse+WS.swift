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
}
