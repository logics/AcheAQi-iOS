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
    
    static var baseDomain = "http://127.0.0.1:8000"
    static var basePath = "/api/v1"
    static var baseURL = baseDomain + basePath
    
    static func urlBy<T>(type: T.Type) -> String? where T : Decodable {
        switch type {
        case is Produtos.Type:      return baseURL + "/produtos"
        case is Categorias.Type:    return baseURL + "/categorias"
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
    
    static func requestAuthByAppleSignIn(appleIDCredential: ASAuthorizationAppleIDCredential, completionHandler: @escaping LoginResultHandler) {
        
        let url = Constants.APIURL + "/login_check_apple"
        
        let params = [
            "uid": appleIDCredential.user,
            "identityToken": String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? "",
            "authCode": String(data: appleIDCredential.authorizationCode!, encoding: .utf8) ?? "",
            "email": appleIDCredential.email ?? "",
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
                
            case .failure(let error):
                
                debugPrint("An error ocurred when trying to auth user by social from API. Error: ", error)
                
                completionHandler(nil, nil, response.errorMessage, false)
            }
        }
    }
    
    static func requestPasswordReset(usernameOrEmail: String, result: @escaping APIResult) {
        
        let url = baseURL + "/users/lostpassword"
        
        let params = ["usernameoremail": usernameOrEmail] as [String: Any]
        
        Alamofire.request(url, method: .post, parameters: params).validate().responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.errorMessage ?? "Error when request password reset")
            }
            result(response)
        }
    }
}
