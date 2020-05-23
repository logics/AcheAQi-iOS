//
//  ResetPassViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 14/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Spring

class ResetPassViewController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet var successView: UIView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
    }
    
    @IBAction func send(_ sender: UIButton) {
        sender.animatePop { finished in
            if finished {
                self.sendDataToWS()
            }
        }
    }
    
    private func sendDataToWS() {
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), email.length > 0 else {
            AlertController.showAlert(message: "Por favor, informe o seu e-mail ou usuário de cadastro.")
            return
        }
        
        startAnimating()
        
        API.requestPasswordReset(usernameOrEmail: email) { response in
            self.stopAnimating()
            
            if response.result.isSuccess {
                self.showSuccess()
            } else {
                AlertController.showAlert(message: response.errorMessage ?? "Não foi possível redefinir a sua senha. Por favor tente novamente mais tarde.")
            }
        }
    }
    
    private func showSuccess() {
        
        successView.alpha = 0.0
        successView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.successView)
                        
        successView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        successView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        successView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -12).isActive = true

        UIView.animate(withDuration: 0.35, animations: {
            self.mainStackView.alpha = 0.0
        }) { finished in
            
            if finished {
                self.mainStackView.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 0.35) {
                self.successView.alpha = 1.0
            }
        }
    }
}
extension ResetPassViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            sendDataToWS()
        default: break
        }
        
        return true
    }
}
