//
//  Constants.swift
//  Testie
//
//  Created by Romeu Godoi on 26/11/16.
//  Copyright © 2016 Logics Tecnologia e Serviços. All rights reserved.
//

import UIKit

let UserDidLoginNotification = Bundle.main.bundleIdentifier! + ".user-did-login-notification"
let UserDidLogoffNotification = Bundle.main.bundleIdentifier! + ".user-did-logoff-notification"
let UserDidUpdateNotification = Bundle.main.bundleIdentifier! + ".user-did-update-notification"

struct NotificationAction {
    static let open = "open"
}

struct Constants {
    
//    static let baseAPIURL: String = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String

    #if DEBUG
        static let baseAPIURL: String = "http://localhost:8000"
    #else
        static let baseAPIURL: String = "https://app.acheaqi.com.br"
    #endif

    private static let apiVersion: String = Bundle.main.object(forInfoDictionaryKey: "API_VERSION") as! String
    static let APIURL = baseAPIURL + "/api/" + apiVersion
    
    static let API_LOGIN_URL = baseAPIURL + "/api/login_check"
    static let USER_TOKEN_TO_CREATE = "e29797b6e51f82262cea841d53f28eee1102796c"
    
    static let privacyURL = baseAPIURL + "/terms/privacy?inApp=1"
    static let termsURL = baseAPIURL + "/terms/service?inApp=1"
    
    static let appID = "1451433136"
    
    // Constantes p/ regras do Sistema de pagamentos com sistema anti-fraude
    // =========================================
    
    static let isPaymentSandbox = true
    
    static let fingerPrintServer = "h.online-metrix.net"
    
    // MID usado para gerar o fingerPrint device ID para enviar ao anti-fraude na hora do pagamento
    static let afMID = isPaymentSandbox ? "braspag" : "braspag_split_logics"
    static let afOrgID = isPaymentSandbox ? "1snn5n9w" : "k8vif92e"
    // =========================================

    static let WSIdentificationKey = "id"
    static let WSDateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    static let debugCookie = "XDEBUG_SESSION=PHPSTORM"
    static let dataKey = "data"
    static let countDataKey = "total"
    
    static let defaultPassword = "LogicsMasterGo#2020"
    
    static let feedbackEmail = "suporte@logics.com.br"
    
//    static let defaultBlueBarTint = UIColor(r: 0, g: 172, b: 236, alpha: 1)
    
    static let createdAt = "createdAt"
    static let updatedAt = "updatedAt"
    
    static let termsStr = "Termos de Uso"
    static let privacyStr = "Politica de Privacidade"
    
    static func termsAttributtedString() -> NSAttributedString {
        
        let fontSize: CGFloat = 15.0
        let fontDefault = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        let colorDefault = UIColor(r: 104, g: 104, b: 104, alpha: 1)
        
        let defaultAttr = [
            NSAttributedString.Key.font: fontDefault,
            NSAttributedString.Key.foregroundColor: colorDefault,
        ]
        
        let termsLinkString = NSMutableAttributedString(string: Self.termsStr, attributes:[
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium),
            NSAttributedString.Key.foregroundColor: UIColor(r: 0, g: 145, b: 147, alpha: 1),
        ])
        
        let privacyLinkString = NSMutableAttributedString(string: Self.privacyStr, attributes:[
//            NSAttributedString.Key.link: URL(string: Self.privacyURL)!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium),
            NSAttributedString.Key.foregroundColor: UIColor(r: 0, g: 145, b: 147, alpha: 1),
        ])
        
        let fullAttributedString = NSMutableAttributedString(string: "Ao se registrar você estará automaticamente concordando como nossos ", attributes: defaultAttr)
        
        fullAttributedString.append(termsLinkString)
        fullAttributedString.append(NSMutableAttributedString(string: " e a nossa ", attributes: defaultAttr))
        fullAttributedString.append(privacyLinkString)
        fullAttributedString.append(NSMutableAttributedString(string: ".", attributes: defaultAttr))
        
        return fullAttributedString
    }
}

extension Constants {
    static let defaultSeparatorColor = UIColor(r: 230, g: 230, b: 230, alpha: 1)
    static let navBarDefaultColor = UIColor(red:0.113, green:0.411, blue:0.333, alpha:1)
}
