//
//  EnderecoFormViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 04/01/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit
import Spring
import Veil

class EnderecoFormViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logradouroTextField: DesignableTextField!
    @IBOutlet weak var numeroTextField: DesignableTextField!
    @IBOutlet weak var complementoTextField: DesignableTextField!
    @IBOutlet weak var cepTextField: DesignableTextField!
    @IBOutlet weak var bairroTextField: DesignableTextField!
    @IBOutlet weak var cidadeTextField: DesignableTextField!
    @IBOutlet weak var estadoTextField: DesignableTextField!
    @IBOutlet weak var sendButton: DesignableButton!
    
    var firstResponder: UIControl?
    
    let statePicker = UIPickerView()
    let ufs = [
        "Selecione",
        "AC",
        "AL",
        "AP",
        "AM",
        "BA",
        "CE",
        "DF",
        "ES",
        "GO",
        "MA",
        "MS",
        "MT",
        "MG",
        "PA",
        "PB",
        "PR",
        "PE",
        "PI",
        "RJ",
        "RN",
        "RS",
        "RO",
        "RR",
        "SC",
        "SP",
        "SE",
        "TO",
    ]
    
    var endereco: Endereco?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statePicker.delegate = self
        statePicker.dataSource = self
        
        cepTextField.addTarget(self, action: #selector(cepDidChange(_:)), for: .allEditingEvents)
        
        updateViews()
    }
    
    // MARK: - IBActions
    
    @IBAction func save(_ sender: UIButton) {
        
        resignFirstResponder(sender)
        
        sender.animatePop { finished in
            if finished {
                self.validateAndSendDataToWS()
            }
        }
    }
    
    @IBAction func resignFirstResponder(_ sender: Any) {
        UIApplication.shared.resignCurrentResponder()
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        estadoTextField.inputView = statePicker
    }
    
    fileprivate func validateAndSendDataToWS() {
        
        guard isValid() else { return }
        
        let address = Endereco(logradouro: logradouroTextField.text!,
                               complemento: complementoTextField.text ?? "",
                               numero: numeroTextField.text ?? "SN",
                               estado: estadoTextField.text!,
                               cidade: cidadeTextField.text!,
                               bairro: bairroTextField.text!,
                               cep: cepTextField.text!)
        
        startAnimating()
        
        API.saveAddress(address) { response in
            self.stopAnimating()
            
            guard response.result.isSuccess else {
                AlertController.showAlert(message: response.errorMessage ?? "Não foi possivel salvar os dados, por favor tente novamente mais tarde.")
                return
            }
            
            self.endereco = response.result.value
            
            AlertController.showAlert(title: "Sucesso", message: "Endereço cadastrado com sucesso!", okAction:  {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    private func isValid() -> Bool {
        
        guard let logradouro = logradouroTextField.text, logradouro.length > 2 else {
            logradouroTextField.becomeFirstResponder()
            AlertController.showAlert(message: "Por favor informe o logradouro.")
            return false
        }
        guard let uf = estadoTextField.text, uf.length == 2 else {
            estadoTextField.becomeFirstResponder()
            AlertController.showAlert(message: "Por favor informe o estado.")
            return false
        }
        guard let cidade = cidadeTextField.text, cidade.length > 2 else {
            cidadeTextField.becomeFirstResponder()
            AlertController.showAlert(message: "Por favor informe a cidade.")
            return false
        }
        guard let bairro = bairroTextField.text, bairro.length > 2 else {
            bairroTextField.becomeFirstResponder()
            AlertController.showAlert(message: "Por favor informe o bairro/setor.")
            return false
        }
        guard let cep = cepTextField.text, cep.length >= 8 else {
            cepTextField.becomeFirstResponder()
            AlertController.showAlert(message: "Por favor informe CEP.")
            return false
        }
        
        return true
    }
    
    @objc private func cepDidChange(_ sender: UITextField) {
        let cepMask = Veil(pattern: "#####-###")
        
        guard let currentText = sender.text else  {
            return
        }
        
        sender.text = cepMask.mask(input: currentText, exhaustive: false)
    }
}

extension EnderecoFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ufs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ufs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let uf = ufs[row]
        estadoTextField.text = uf != "Selecione" ? uf : nil
    }
}

extension EnderecoFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case logradouroTextField:
                numeroTextField.becomeFirstResponder()
            case numeroTextField:
                complementoTextField.becomeFirstResponder()
            case complementoTextField:
                cepTextField.becomeFirstResponder()
            case cepTextField:
                bairroTextField.becomeFirstResponder()
            case bairroTextField:
                cidadeTextField.becomeFirstResponder()
            case cidadeTextField:
                estadoTextField.becomeFirstResponder()
            default:
                break
        }
        
        return true
    }
}
