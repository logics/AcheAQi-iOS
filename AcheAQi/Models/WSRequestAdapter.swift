//
//  WSRequestAdapter.swift
//  Logics
//
//  Created by Romeu Godoi on 16/01/19.
//  Copyright © 2017 Oconcurs. All rights reserved.
//

import UIKit
import Alamofire

class WSRequestAdapter: RequestAdapter, RequestRetrier {
    
    private let lock = NSLock()
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        #if DEBUG
        urlRequest.addValue(Constants.debugCookie, forHTTPHeaderField: "Cookie")
        #endif
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let jwt = Login.shared.jwtToken {
            urlRequest.addValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            let url = request.request?.url,
            url.absoluteString != Constants.API_LOGIN_URL {
            
            // Show Login VC
            DispatchQueue.main.async {
                completion(false, 0.0)
                
                AlertController.showLoginAlert()
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private Methods
    
    private func showLoginScreen() {
        
        guard let loginVC = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController() else { return }
        
        if let vc = UIApplication.shared.currentViewController() {
            vc.present(loginVC, animated: true, completion: nil)
        }
    }
}

