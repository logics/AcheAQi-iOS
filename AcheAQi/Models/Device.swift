//
//  Device.swift
//  Joias
//
//  Created by Romeu Godoi on 11/11/17.
//  Copyright © 2017 doisdoissete. All rights reserved.
//

import UIKit

class Device: NSObject {
    
    static let prefixKey = "br.com.logics."
    
    let uuidKey = Device.prefixKey + "uuid"
    let iosVersionKey = Device.prefixKey + "iosVersionKey"
    let appVersionKey = Device.prefixKey + "appVersionKey"
    let buildVersionKey = Device.prefixKey + "buildVersionKey"
    let alertAllowedKey = Device.prefixKey + "alertAllowedKey"
    let badgeAllowedKey = Device.prefixKey + "badgeAllowedKey"
    let soundAllowedKey = Device.prefixKey + "soundAllowedKey"
    let deviceNameKey = Device.prefixKey + "deviceNameKey"
    
    let defaults = UserDefaults.standard
    
    // Can't init is singleton
    private override init() { }
    
    // MARK: Shared Instance
    static let shared = Device()
    
    
    let name: String = UIDevice.current.name
    let deviceModel: String = UIDevice.current.deviceType.displayName
    let iosVersion: String = UIDevice.current.systemVersion
    let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
    let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    let badgeCount = UIApplication.shared.applicationIconBadgeNumber
    
    var userExternalID: NSNumber? {
        get {
            return defaults.value(forKey: Device.prefixKey + "userExternalID") as? NSNumber
        }
        set {
            defaults.setValue(newValue, forKey: Device.prefixKey + "userExternalID")    
        }
    }
    
    var deviceToken: String? {
        get {
            return defaults.value(forKey: Device.prefixKey + "deviceToken") as? String
        }
        set {
            defaults.setValue(newValue, forKey: Device.prefixKey + "deviceToken")
        }
    }
    
    var alertAllowed: Bool {
        set {
            defaults.setValue(newValue, forKey: alertAllowedKey)
        }
        get {
            return defaults.value(forKey: alertAllowedKey) as? Bool ?? false
        }
    }
    
    var badgeAllowed: Bool {
        set {
            defaults.setValue(newValue, forKey: badgeAllowedKey)
        }
        get {
            return defaults.value(forKey: badgeAllowedKey) as? Bool ?? false
        }
    }
    
    var soundAllowed: Bool {
        set {
            defaults.setValue(newValue, forKey: soundAllowedKey)
        }
        get {
            return defaults.value(forKey: soundAllowedKey) as? Bool ?? false
        }
    }
    
    func save() {
        if DeviceType.current != .simulator {
            API.saveDevice(self) { response in
                
                switch response.result {
                case .success:
                    self.defaults.synchronize()
                case .failure: break
                }
            }
        }
    }
    
    func clearAndSave() {
        if DeviceType.current != .simulator {
            API.removeDevice(deviceID: deviceIdentifier) { response in
                switch response.result {
                case .success:
                    self.userExternalID = nil
                    self.defaults.synchronize()
                case .failure: break
                }
            }
        }
    }
}
