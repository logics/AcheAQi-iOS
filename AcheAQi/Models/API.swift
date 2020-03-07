//
//  API.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 19/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    static var baseDomain = "http://127.0.0.1:8000"
    static var basePath = "/api/v1"
    
    static func urlBy<T>(type: T.Type) -> String? where T : Decodable {
        switch type {
        case is Produtos.Type:      return baseDomain + basePath + "/produtos"
        case is Categorias.Type:    return baseDomain + basePath + "/categorias"
        default:
            return nil
        }
    }
    
    static func fetchProdutos(page: Int = 1, params: Parameters?, completionHandler: @escaping (DataResponse<Produtos>) -> Void) {
        guard let url = urlBy(type: Produtos.self) else { return }
        
        Alamofire.request(url, method: .get, parameters: params).responseProdutos { response in
            completionHandler(response)
        }
    }
    
    static func fetchCategorias(page: Int = 1, completionHandler: @escaping (DataResponse<Categorias>) -> Void) {
        guard let url = urlBy(type: Categorias.self) else { return }
        
        Alamofire.request(url, method: .get).responseCategorias { response in
            completionHandler(response)
        }
    }
}
