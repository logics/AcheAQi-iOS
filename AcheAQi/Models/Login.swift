//
//  Login.swift
//  Testie
//
//  Created by Romeu Godoi on 07/08/17.
//  Copyright © 2017 Oconcurs. All rights reserved.
//

import Foundation

class Login {

    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    static let shared = Login()
    
    fileprivate let prefixKey = "br.com.AcheAQi."

    let defaults = UserDefaults.standard
    
    var userExternalID: NSNumber? {
        get {
            return self.defaults.value(forKey: prefixKey + "userExternalID") as? NSNumber
        }
        set {
            self.defaults.set(newValue, forKey: prefixKey + "userExternalID")
        }
    }
    
    var startedNewSection = false
    
    var isLogado: Bool {
        get {
            return self.defaults.value(forKey: prefixKey + "isLogado") as? Bool == true
        }
        set {
            self.startedNewSection = self.isLogado == false && newValue == true
            self.defaults.setValue(newValue, forKey: prefixKey + "isLogado")
        }
    }
    
    var nickname: String? {
        get {
            let username = KeychainWrapper.standard.string(forKey: prefixKey + "nickname") ?? ""
            return username
        }
        set {
            KeychainWrapper.standard.set(newValue ?? "", forKey: prefixKey + "nickname")
        }
    }
    
    var email: String? {
        get {
            let mail = KeychainWrapper.standard.string(forKey: prefixKey + "email") ?? ""
            return mail
        }
        set {
            KeychainWrapper.standard.set(newValue ?? "", forKey: prefixKey + "email")
        }
    }

    var nome: String? {
        get {
            return self.defaults.value(forKey: prefixKey + "nome") as? String
        }
        set {
            self.defaults.setValue(newValue, forKey: prefixKey + "nome")
        }
    }
    
    var avatarPath: String? {
        get {
            return self.defaults.value(forKey: prefixKey + "avatarPath") as? String
        }
        set {
            self.defaults.setValue(newValue, forKey: prefixKey + "avatarPath")
        }
    }

    var jwtToken: String? {
        get {
            let token = KeychainWrapper.standard.string(forKey: prefixKey + "jwtToken") ?? ""
            return token
        }
        set {
            KeychainWrapper.standard.set(newValue ?? "", forKey: prefixKey + "jwtToken")
        }
    }
    
    var deviceToken: String? {
        get {
            return self.defaults.value(forKey: prefixKey + "deviceToken") as? String
        }
        set {
            self.defaults.setValue(newValue, forKey: prefixKey + "deviceToken")
        }
    }
    
//    func saveSession(of user: Usuario) {
//
//        self.isLogado = true
//        self.userExternalID = user.externalID
//        self.save()
//
//        let device = Device.shared
//        device.userExternalID = user.externalID
//        device.save()
//    }

    func setlastEmailAppleSignIn(of userID: String, email: String?) {
        KeychainWrapper.standard.set(email ?? "", forKey: prefixKey + userID + "email")
    }
    
    func lastEmailAppleSignIn(of userID: String) -> String? {
        let mail = KeychainWrapper.standard.string(forKey: prefixKey + userID + "email")
        return mail
    }

    func save() {
        defaults.synchronize()
        
        if isLogado && startedNewSection {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: UserDidLoginNotification), object: nil, userInfo: ["date": Date()]))
        }
    }
    
    func clear() {
        userExternalID = nil
        isLogado = false
        jwtToken = nil
        deviceToken = nil
    }
    
    func logoff() {
//        Device.shared.clearAndSave()
        
        clear()
        save()
        
        // Post User Login Notification Center
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: UserDidLogoffNotification), object: nil, userInfo: ["date": Date()]))
    }
    
    func parseUserData(json: [String: Any]) {
        self.userExternalID = json["id"] as? NSNumber
        self.nome = json["nome"] as? String
        self.nickname = json["username"] as? String
        self.email = json["email"] as? String
        self.avatarPath = json["avatar"] as? String
    }
}
