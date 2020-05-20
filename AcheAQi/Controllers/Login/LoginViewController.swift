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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        print("Login...")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
