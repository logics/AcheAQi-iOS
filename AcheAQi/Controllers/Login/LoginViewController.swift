//
//  LoginViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 07/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import AuthenticationServices
import Spring

fileprivate var segueRegister = "Register Segue"

class LoginViewController: AppleSignInController {

    @IBOutlet weak var stackCenterView: UIStackView!
    @IBOutlet weak var userTextField: DesignableTextField!
    @IBOutlet weak var passTextField: DesignableTextField!
    @IBOutlet weak var sendButton: DesignableButton!
    @IBOutlet weak var lostPasswordButton: UIButton!
    @IBOutlet weak var registerButton: DesignableButton!
    
    var userIdentifier: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: Notification.Name(rawValue: UserDidLoginNotification), object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func login(_ sender: DesignableButton) {
        sender.animatePop { finished in
            if finished {
                self.callLoginAPI()
            }
        }
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        sender.animatePop { finished in
            if finished {
                self.showRegisterVC()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        // Add SignIn 
        stackCenterView.addArrangedSubview(appleLoginButton)
        lostPasswordButton.applyUnderline()
    }
    
    private func callLoginAPI() {
        
        if !validate() { return }
        
        startAnimating()
        
        let username = userTextField.text!
        let password = passTextField.text!
        
        API.requestAuth(username: username, password: password) { (userInfo, token, errMsg, success) in
            self.stopAnimating()
            
            if !success {
                let msg = errMsg ?? "Não foi possivel logar na plataforma AcheAQi. Por favor, entre em contato com a nossa equipe, nos envie um feedback, ou tente novamente mais tarde."
                
                AlertController.showAlert(message: msg)
            }
        }
    }
    
    private func validate() -> Bool {
        
        var isValid = true
        let username = userTextField.text ?? ""
        let password = passTextField.text ?? ""
        
        if username.length == 0 {
            AlertController.showAlert(message: "Informe seu usuário.")
            isValid = false
        }
        else if password.length == 0 {
            AlertController.showAlert(message: "Informe a sua senha.")
            isValid = false
        }
        
        return isValid
    }
    
    private func showRegisterVC() {
        performSegue(withIdentifier: segueRegister, sender: self)
    }
    
    @objc private func didLogin() {
        close()
    }
    
    private func close() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userTextField:         passTextField.becomeFirstResponder()
        case passTextField:
            passTextField.resignFirstResponder()
            callLoginAPI()
        default: break
        }
        
        return true
    }
}
