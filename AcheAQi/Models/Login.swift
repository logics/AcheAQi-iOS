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
    
    fileprivate let prefixKey = "br.com.QuadrasNet."

    let defaults = UserDefaults.standard
    
    var userExternalID: NSNumber? {
        
        get {
            return self.defaults.value(forKey: prefixKey + "userExternalID") as? NSNumber
        }
        set {
            self.defaults.set(newValue, forKey: prefixKey + "userExternalID")
        }
    }
    
    var isLogado: Bool {
        get {
            return self.defaults.value(forKey: prefixKey + "isLogado") as? Bool == true
        }
        set {
            self.defaults.setValue(newValue, forKey: prefixKey + "isLogado")
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
    
    func save() {
        defaults.synchronize()
    }
    
    func clear() {
        userExternalID = nil
        isLogado = false
        jwtToken = nil
        deviceToken = nil
    }
    
//    func logoff() {
//        Device.shared.clearAndSave()
//        
//        clear()
//        GIDSignIn.sharedInstance().signOut()
//        LoginManager().logOut()
//        
//        save()
//        
//        // Post User Login Notification Center
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: UserDidLogoffNotification), object: nil, userInfo: ["date": Date()]))
//    }
}
