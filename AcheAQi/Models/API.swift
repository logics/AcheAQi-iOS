//
//  API.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 19/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation
import Alamofire
import AuthenticationServices

typealias APIResult = (DataResponse<Any>) -> ()
typealias LoginResultHandler = (_ userInfo: [String: Any]?, _ token: String?, _ errorMessage: String?, _ success: Bool) -> ()

class API {
    
    static var baseURL = Constants.APIURL
    
    static func urlBy<T>(type: T.Type) -> String? where T : Decodable {
        switch type {
            case is Produtos.Type:      return baseURL + "/produtos"
            case is Categorias.Type:    return baseURL + "/categorias"
            case is Cartoes.Type:       return baseURL + "/cartoes"
            case is Pedidos.Type:       return baseURL + "/pedidos"
            case is Pagamentos.Type:    return baseURL + "/pagamentos"
            case is Enderecos.Type,     is Endereco.Type:     return baseURL + "/enderecos"
            default:
                return nil
        }
    }
    
    static func fetchProdutos(page: Int = 1, params: Parameters, completionHandler: @escaping (DataResponse<Produtos>) -> Void) {
        guard let url = urlBy(type: Produtos.self) else { return }
        
        var parameters = params
        parameters["page"] = page
        
        Alamofire.request(url, method: .get, parameters: parameters).responseProdutos { response in
            completionHandler(response)
        }
    }
    
    static func fetchCategorias(page: Int = 1, completionHandler: @escaping (DataResponse<Categorias>) -> Void) {
        guard let url = urlBy(type: Categorias.self) else { return }
        
        let params = ["page" : page]

        Alamofire.request(url, method: .get, parameters: params).responseCategorias { response in
            completionHandler(response)
        }
    }
    
    static func fetchPedidoAberto(page: Int = 1, completionHandler: @escaping (Bool, Pedido?) -> Void) {
        guard let url = urlBy(type: Pedidos.self) else { return }
        
        let params: [String: Any] = [
            "page": page,
            "finalizado": false,
        ]
        
        Alamofire.request(url, method: .get, parameters: params).responseModel { (response: DataResponse<Pedidos>) in
            let success = response.result.isSuccess
            let pedido = response.result.value?.first
            
            completionHandler(success, pedido)
        }
    }

    static func fetchModel<T: Codable>(page: Int = 1, completionHandler: @escaping (DataResponse<T>) -> Void) {
        guard let url = urlBy(type: T.self) else { return }
        
        let params = ["page" : page]
        
        Alamofire.request(url, method: .get, parameters: params).validate().responseModel{ (response: DataResponse<T>) in
            completionHandler(response)
        }
    }
    
    // MARK: - Devices

    static func saveDevice(_ device: Device, result: @escaping APIResult) {
        
        let url = baseURL + "/devices"
        
        var params = [
            "deviceId": device.deviceIdentifier,
            "appVersion": device.appVersion,
            "buildVersion": device.buildVersion,
            "os": "iOS",
            "osVersion": device.iosVersion,
            "alertAllowed": device.alertAllowed,
            "badgeAllowed": device.badgeAllowed,
            "soundAllowed": device.soundAllowed,
            "deviceName": device.name,
            "deviceModel": device.deviceModel,
            "badgeCount": device.badgeCount,
            ] as [String: Any]
        
        if let token = device.deviceToken {
            params["deviceToken"] = token
        }
        
        Alamofire.request(url, method: .post, parameters: params).validate().responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.errorMessage ?? "Error when saving device")
            }
            result(response)
        }
    }
    
    static func removeDevice(deviceID: String, result: @escaping APIResult) {
        
        let url = baseURL + "/devices" + deviceID
        
        Alamofire.request(url, method: .delete).validate().responseJSON { response in
            result(response)
        }
    }
    
    // MARK: - Usuario
    
    static func sendUserData(params: [String: Any], avatarData: Data?, userId: NSNumber? = nil, result: @escaping APIResult, onError: ((Error?) -> ())?) {
        let url = baseURL + (userId != nil ? "/users/\(userId!)/update" : "/users")
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                        
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = avatarData {
                multipartFormData.append(data, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64(), to: url, method: .post, headers: headers) { (uploadResult) in
            switch uploadResult {
            case .success(let upload, _, _):
                upload.validate().responseJSON { response in
                    result(response)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    static func requestAuth(username: String, password: String, completionHandler: @escaping LoginResultHandler) {
        
        let url = Constants.API_LOGIN_URL
        
        let params = ["username": username, "password": password]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
            
            let result = response.result
            
            switch result {
            case .success:
                
                if let jsonData = result.value as? [String: Any],
                    let jwtToken = jsonData["token"] as? String,
                    let userData = jsonData["data"] as? [String: Any] {
                    
                    let login = Login.shared
                    login.jwtToken = jwtToken
                    login.parseUserData(json: userData)
                    login.isLogado = true
                    login.save()
                    
                    completionHandler(nil, jwtToken, nil, true)
                } else {
                    completionHandler(nil, nil, response.errorMessage, false)
                }
                
            case .failure(let error):
                
                debugPrint("An error ocurred when trying to feth servers from API. Error: ", error)
                
                completionHandler(nil, nil, response.errorMessage, false)
            }
        }
    }
    
    @available(iOS 13.0, *)
    static func requestAuthByAppleSignIn(appleIDCredential: ASAuthorizationAppleIDCredential, completionHandler: @escaping LoginResultHandler) {
        
        let url = Constants.APIURL + "/login_check_apple"
        let uid = appleIDCredential.user
        let email = appleIDCredential.email ?? (Login.shared.lastEmailAppleSignIn(of: uid) ?? "")
        
        let params = [
            "uid": uid,
            "identityToken": String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? "",
            "authCode": String(data: appleIDCredential.authorizationCode!, encoding: .utf8) ?? "",
            "email": email,
            "firstname": appleIDCredential.fullName?.givenName ?? "",
            "lastname": appleIDCredential.fullName?.familyName ?? "",
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
            
            let result = response.result
            
            switch result {
            case .success:
                
                if let jsonData = result.value as? [String: Any],
                    let jwtToken = jsonData["token"] as? String,
                    let userData = jsonData["data"] as? [String: Any] {
                    
                    let login = Login.shared
                    login.jwtToken = jwtToken
                    login.parseUserData(json: userData)
                    login.isLogado = true
                    login.save()
                    
                    completionHandler(nil, jwtToken, nil, true)
                } else {
                    completionHandler(nil, nil, response.errorMessage, false)
                }
                
            case .failure:
                completionHandler(nil, nil, response.errorMessage, false)
            }
        }
    }
    
    static func requestPasswordReset(usernameOrEmail: String, result: @escaping APIResult) {
        
        let url = baseURL + "/users/lostpassword"
        
        let params = ["usernameoremail": usernameOrEmail] as [String: Any]
        
        Alamofire.request(url, method: .post, parameters: params).validate().responseJSON { response in
            result(response)
        }
    }
    
    // MARK: - CARTOES
    
    static func fetchCards(page: Int = 1, params: Parameters = Parameters(), completionHandler: @escaping (DataResponse<Cartoes>) -> Void) {
        guard let url = urlBy(type: Cartoes.self) else { return }
        
        var parameters = params
        parameters["page"] = page
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseModel { (response: DataResponse<Cartoes>) in
            completionHandler(response)
        }
    }
    
    static func tokenizeCard(cartao: Cartao, completionHandler: @escaping APIResult) {
        guard let url = urlBy(type: Cartoes.self) else { return }
        
        let params = cartao.dictionary
        
        Alamofire.request(url + "/tokenize", method: .post, parameters: params).validate().responseJSON { response in
            completionHandler(response)
        }
    }
    
    static func deleteCard(cartao: Cartao, completionHandler: @escaping APIResult) {
        guard let url = urlBy(type: Cartoes.self) else { return }
        
        let path = String(format: "%@/%d", url, cartao.id)
        
        Alamofire.request(path, method: .delete).validate().responseJSON { response in
            completionHandler(response)
        }
    }
    
    
    // MARK: - ENDERECOS
    
    static func saveAddress(_ address: Endereco, result: @escaping (DataResponse<Endereco>) -> ()) {
        var url = urlBy(type: Enderecos.self)!
        
        let params = [
            "tipo": "entrega",
            "logradouro": address.logradouro,
            "complemento": address.complemento ?? "",
            "numero": address.numero ?? "",
            "estado": address.estado,
            "cidade": address.cidade,
            "bairro": address.bairro,
            "cep": address.cep
        ] as [String: Any]
        
        var method = HTTPMethod.post
        
        if let id = address.id {
            method = .put
            url = String(format: "%@/%d", url, id)
        }
        
        Alamofire
            .request(url, method: method, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseModel { (response: DataResponse<Endereco>) in
                result(response)
            }
    }
    
    static func deleteAddress(id: Int, completionHandler: @escaping APIResult) {
        let url = String(format: "%@/%d", urlBy(type: Enderecos.self)!, id)
        
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default).validate().responseJSON { response in
            completionHandler(response)
        }
    }
    
    // MARK: - Pedidos
    
    static func savePedido(_ pedido: Pedido, empresaId: Int16, result: @escaping (DataResponse<Pedido>) -> ()) {
        let url = urlBy(type: Pedidos.self)!

        var items = [[String: Any]]()
        
        for item in pedido.itens {
            items.append([
                "produto": item.produto.id,
                "qtd": item.qtd,
                "valorUnitario": item.valorUnitario,
            ])
        }

        var params = [
            "formaPagamento": pedido.formaPagamento,
            "empresa": empresaId,
            "entrega": pedido.entrega,
            "itens": items,
        ] as [String : Any]
        
        if let endereco = pedido.endereco {
            params["endereco"] = endereco.id!
        }
        
        if let cartao = pedido.cartao {
            params["cartao"] = cartao.id
        }
        
        Alamofire
            .request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseModel { (response: DataResponse<Pedido>) in
                result(response)
            }
    }
    
    // MARK: - Pagamentos
    
    static func processPayment(pedido: Pedido, cvv: Int, result: @escaping (DataResponse<Pagamento>) -> ()) {
        let url = urlBy(type: Pagamentos.self)!
        
        let params = [
            "empresa": pedido.empresa!.id,
            "nomeCliente": Login.shared.nome!,
            "cartao": pedido.cartao!.id,
            "pedido": pedido.id!,
            "cvv": cvv,
        ] as [String: Any]
        
        Alamofire
            .request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseModel { (response: DataResponse<Pagamento>) in
                result(response)
            }
    }
}
