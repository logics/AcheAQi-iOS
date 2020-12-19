//
//  FormCartaoTableViewController.swift
//  SabbePay
//
//  Created by Romeu Godoi on 08/01/19.
//  Copyright © 2019 Logics Software. All rights reserved.
//

import UIKit

class FormCartaoTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nrCartaoTextField: UITextField!
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var validadeTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var visaImageView: UIImageView!
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var amexImageView: UIImageView!
    @IBOutlet weak var dinersImageView: UIImageView!
    @IBOutlet weak var genericCardImageView: UIImageView!
    @IBOutlet weak var isDefaultSwich: UISwitch!
    
    var currentResponder: UIResponder?
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    var cardType: CardType?
    var cardTypeString: String?
    var brand: String?
    var cartao: Cartao?
    
    lazy var validadePickerView: MonthYearPickerView = {
        let datePicker = MonthYearPickerView()
        
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        validadeTextField.inputView = validadePickerView
        
        setupToolBar(of: validadeTextField)
        
        nrCartaoTextField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
        validadePickerView.onDateSelected = { (month: Int, year: Int) in
            self.validadeTextField.text = String(format: "%02d/%d", month, year)
        }
    }

    
    // MARK: - IBActions
    
    @IBAction func hideKeyboard(_ sender: Any) {
        currentResponder?.resignFirstResponder()
    }
    
    @IBAction func tapOnNrCartao(_ sender: UITapGestureRecognizer) {
        nrCartaoTextField.becomeFirstResponder()
    }
    
    @IBAction func tapOnName(_ sender: UITapGestureRecognizer) {
        nomeTextField.becomeFirstResponder()
    }
    
    @IBAction func tapOnValidade(_ sender: UITapGestureRecognizer) {
        validadeTextField.becomeFirstResponder()
    }
    
    @IBAction func tapOnCvv(_ sender: UITapGestureRecognizer) {
        cvvTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Private Functions
    
    private func setupToolBar(of textField: UITextField) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        toolBar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: textField, action: #selector(resignFirstResponder))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), okButton], animated: true)
        
        textField.inputAccessoryView = toolBar
    }
    
    @objc private func changedDate(sender: UIDatePicker) {
        validadeTextField.text = sender.date.formattedDate(style: .medium)
    }
    
    private func setCard(forState cardState: CardState) {
        
        self.cardType = nil
        
        visaImageView.alpha = 0.3
        masterImageView.alpha = 0.3
        amexImageView.alpha = 0.3
        dinersImageView.alpha = 0.3
        genericCardImageView.alpha = 0.3
        
        switch cardState {
        case .identified(let cardType):
            
            self.cardType = cardType
            self.brand = cardType.toString()
            
            switch cardType {
            case .visa:         visaImageView.alpha = 1.0
            case .masterCard:   masterImageView.alpha = 1.0
            case .amex:         amexImageView.alpha = 1.0
            case .diners:       dinersImageView.alpha = 1.0
            case .discover, .jcb: genericCardImageView.alpha = 1.0
            }
        case .indeterminate: genericCardImageView.alpha = nrCartaoTextField.text!.count > 0 ? 1.0 : 0.3
        case .invalid:       break
        }
    }
    
    @objc private func callBINList(bin: String) {
        BINList.find(bin: bin) { response in
            
            if let json = response.result.value as? [String: Any], let type = json["type"] as? String {
                
                self.cardTypeString = type.capitalizingFirstLetter()
                
                if let bandeira = json["scheme"] as? String {
                    self.brand = bandeira.capitalizingFirstLetter()
                }
            }
        }
    }
    
    // MARK: - Picker View DataSource
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentResponder = textField
        
        tableView.scrollRectToVisible(textField.frame, animated: true)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let completeString = textField.text! + string
        
        if textField == nrCartaoTextField {
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            
            let bin = completeString.replacingOccurrences(of: " ", with: "")
            
            // If is 8 digits call BINList to get more card info
            if bin.count == 8 {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(callBINList(bin:)), object: nil)
                self.perform(#selector(callBINList(bin:)), with: bin)
            }
        }
        else if textField == cvvTextField {
            if let cardType = self.cardType {
                return completeString.count <= cardType.cvvLength
            } else if nrCartaoTextField.text!.length == 0 {
                AlertController.showAlert(title: "Ops!", message: "Por favor, informe o Nr. do cartão primeiro.")
                nrCartaoTextField.becomeFirstResponder()
                return false
            } else if completeString.count > 4 {
                return false
            }
        }
        return true
    }
    
    // MARK: - Card Number Formatter
    // @see https://stackoverflow.com/questions/12083605/formatting-a-uitextfield-for-credit-card-input-like-xxxx-xxxx-xxxx-xxxx/48252437#48252437
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
        
        // Habilita o cartão
        let cardState = CardState(fromPrefix: cardNumberWithoutSpaces)
        setCard(forState: cardState)
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
}

