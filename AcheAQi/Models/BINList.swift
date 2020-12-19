//
//  BINList.swift
//  SabbePay
//
//  Created by Romeu Godoi on 12/01/19.
//  Copyright © 2019 Logics Software. All rights reserved.
//

import Foundation
import Alamofire

private let apiEndpoint = "https://binlist.net/json/"

open class BINList {
//    public static func find(bin: String, completionHandler: @escaping (_ data: String) -> Void) {
    static func find(bin: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        
//        let url = URL(string: apiEndpoint + bin)
        let url = apiEndpoint + bin

        Alamofire.request(url).responseJSON { response in
            completionHandler(response)
        }
        
//        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//            completionHandler(responseString)
//        }
//
//        task.resume()
        
    }
}

