//
//  AppleSignInController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 18/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import AuthenticationServices

/// Criado para dar a possibilidade de uso de target do projeto < 13.0
protocol AppleSignInDelegate {
    func presentationAnchor() -> ASPresentationAnchor
}


@available(iOS 13.0, *)
class AppleSignInController: UIViewController {
    
    var appleUid: String?
    var appleIDCredential: ASAuthorizationAppleIDCredential?
    var presentationAnchor: ASPresentationAnchor!
    var delegate: AppleSignInDelegate!
    
    var appleLoginButton: ASAuthorizationAppleIDButton {
        let btn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
        btn.cornerRadius = 20.0
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        
        return btn
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appleIDCredentialRevoked),
                                               name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                               object: nil)
    }
    
    private func signInWithAppleInWS() {
        startAnimating()
        
        /// After the first Sign In witth Apple, the AuthenticationServices doesn't return email anymore, so
        /// Here we save the email to get it back if have a problem on this SignIn for a second time
        if let uid = appleIDCredential?.user, let email = appleIDCredential?.email {
            Login.shared.setlastEmailAppleSignIn(of: uid, email: email)
            Login.shared.save()
        }
        
        API.requestAuthByAppleSignIn(appleIDCredential: appleIDCredential!) { (userInfo, token, errMsg, success) in
            self.stopAnimating()
            
            if success == false, let msg = errMsg {
                AlertController.showAlert(message: msg)
            }
        }
    }
}

@available(iOS 13.0, *)
extension AppleSignInController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest() //1
        request.requestedScopes = [.fullName, .email] //2

        let authorizationController = ASAuthorizationController(authorizationRequests: [request]) //3
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self //4
        authorizationController.performRequests() //5
    }
    
    @objc func appleIDCredentialRevoked() {
        
        guard let uid = self.appleUid else { return }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        appleIDProvider.getCredentialState(forUserID: uid) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid. Show Home UI Here
                break
            case .revoked:
                // The Apple ID credential is revoked. Handle unlink
                break
            case .notFound:
                // No credential was found. Show login UI.
                break
            default:
                break
            }
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.delegate.presentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            appleIDCredential = credential
            
            signInWithAppleInWS()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        AlertController.showAlert(message: "Não foi possível efetivar login com a Apple. Por favor tente novamente mais tarde, ou reveja as suas configurações de permissões do AcheAQi nos Ajustes do seu dispositivo.")
    }
}
