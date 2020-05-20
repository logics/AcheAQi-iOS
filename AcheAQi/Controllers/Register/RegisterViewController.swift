//
//  RegisterViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 13/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Spring
import AuthenticationServices
import NVActivityIndicatorView
import Alamofire
import AlamofireImage

protocol RegisterDelegate {
    func didFinishRegister(success: Bool, username: String?)
}

class RegisterViewController: AppleSignInController {

    @IBOutlet weak var avatarView: AvatarStroked!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nomeTextField: DesignableTextField!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var usernameTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var passwordConfTextField: DesignableTextField!
    @IBOutlet weak var sendButton: DesignableButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var avatarData: Data?
    var delegate: RegisterDelegate?
    
    var firstname: String? {
        let nome = nomeTextField.text
        
        if var components = nome?.components(separatedBy: " ") {
            
            if components.count > 0 {
                let first = components.removeFirst()
                
                return first
            }
        }
        
        return nome
    }
    
    var lastname: String? {
        let nome = nomeTextField.text
        
        if var components = nome?.components(separatedBy: " ") {
            
            if components.count > 1 {
                components.removeFirst()
                let lastName = components.joined(separator: " ")
                
                return lastName
            }
        }
        
        return nil
    }

    lazy var imagePicker: ImagePicker! = {
        return ImagePicker(presentationController: self, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private Functions
    
    private func setupViews() {
        let login = Login.shared

        if login.isLogado {
            orLabel.removeFromSuperview()
            
            if let path = login.avatarPath, path.length > 0 {
                let url = URL(wsURLWithPath: path)
                
                Alamofire.request(url).responseImage { response in
                    if case .success(let image) = response.result {
                        self.avatarView.image = image
                    }
                }
            }
            
            nomeTextField.text = login.nome
            emailTextField.text = login.email
            usernameTextField.text = login.nickname
            
            sendButton.setTitle("Salvar", for: .normal)

        } else {
            mainStackView.addArrangedSubview(appleLoginButton)
        }
    }
    
    private func sendDataToWS() {
        
        if !validate() { return }
        
        startAnimating()
        
        let login = Login.shared
        
        var params = [
            "username" : usernameTextField.text ?? "",
            "email" : emailTextField.text ?? "",
            "firstname" : firstname ?? "",
            "lastname" : lastname ?? "",
        ] as [String : Any]
        
        if let pass = passwordTextField.text {
            params["plainPassword"] = pass
        }
        
        if login.userExternalID == nil {
            params["token"] = Constants.USER_TOKEN_TO_CREATE
        }
        
        let isUpdating = Login.shared.isLogado
        let errMsgDefault = "Houve um problema ao tentar salvar os dados. Por favor, tente novamente mais tarde."
        
        API.sendUserData(params: params, avatarData: avatarData, userId: login.userExternalID, result: { response in
            self.stopAnimating()
            
            let result = response.result
            
            if result.isSuccess, let userInfo = result.value as? [String: Any] {
                
                let login = Login.shared
                login.parseUserData(json: userInfo)
                login.save()
                
                let msg = isUpdating ? "Alteração realizada com sucesso!" : "Cadastro realizado com sucesso!\nEntre agora com seu usuário e senha."
                
                AlertController.showAlert(title: "Sucesso!", message: msg, style: .normal, okAction: {
                    if let delegate = self.delegate {
                        delegate.didFinishRegister(success: true, username: self.usernameTextField.text)
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else if result.isFailure {
                
                let msg = response.errorMessage ?? errMsgDefault
                
                AlertController.showAlert(title: "Ops!", message: msg, style: .normal, okAction: {
                    if let delegate = self.delegate {
                        delegate.didFinishRegister(success: false, username: nil)
                    }
                })
            }
        }) { error in
            self.stopAnimating()
            
            let msg = error?.localizedDescription ?? errMsgDefault
            
            AlertController.showAlert(title: "Ops!", message: msg, style: .normal, okAction: {
                if let delegate = self.delegate {
                    delegate.didFinishRegister(success: false, username: nil)
                }
            })
        }
    }
    
    private func validate() -> Bool {
        
        if usernameTextField.text == nil || usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).length < 1 {
            AlertController.showAlert(message: "Por favor, informe o nome de usuário.")
            return false
        }
        
        if emailTextField.text == nil {
            AlertController.showAlert(message: "Por favor, informe seu e-mail.")
            return false
        }
        else if emailTextField.text!.isValidEmail() == false {
            AlertController.showAlert(message: "Informe um e-mail válido.")
            return false
        }
        
        if firstname == nil || firstname!.trimmingCharacters(in: .whitespacesAndNewlines).length < 1 {
            AlertController.showAlert(message: "Por favor, informe o seu nome.")
            return false
        }
        
        if !Login.shared.isLogado, passwordTextField.text == nil {
            AlertController.showAlert(message: "Por favor, crie uma senha.")
            return false
        }
        
        if let pass = passwordTextField.text {
            if pass != passwordConfTextField.text {
                AlertController.showAlert(message: "As senhas não conferem.")
                return false
            }
        }

        return true
    }
        
    // MARK: - IBActions
    
    @IBAction func didTapAvatar(_ sender: AvatarStroked) {
        sender.animatePop { finished in
            if finished {
                self.imagePicker.present(from: sender)
            }
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        sender.animatePop { complete in
            if complete {
                self.sendDataToWS()
            }
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

// MARK: - TextField Delegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nomeTextField:         emailTextField.becomeFirstResponder()
        case emailTextField:        usernameTextField.becomeFirstResponder()
        case usernameTextField:     passwordTextField.becomeFirstResponder()
        case passwordTextField:     passwordConfTextField.becomeFirstResponder()
        case passwordConfTextField:
            passwordConfTextField.resignFirstResponder()
            sendDataToWS()
        default: break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let isValid = true
        
        if textField == passwordConfTextField,
            let text = textField.text,
            let textRange = Range(range, in: text) {
            
            let textValue = text.replacingCharacters(in: textRange, with: string)
            
            let passConfere = textValue == passwordTextField.text
            
            passwordConfTextField.textColor = passConfere ? .black : .red
        }

        return isValid
    }
}

// MARK: - Image Picker Delegate
extension RegisterViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.avatarView.image = image
        
        avatarData = image?.jpegData(compressionQuality: 0.7)
    }
}
