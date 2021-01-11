//
//  CVVViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/01/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit
import Spring
import Veil

class CVVViewController: UIViewController {

    @IBOutlet weak var cvvView: CVVCardView!
    @IBOutlet weak var cvvTextField: DesignableTextField!
    @IBOutlet weak var sendButton: DesignableButton!
    
    var card: Cartao?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvvTextField.addTarget(self, action: #selector(didChangeCVVText(_:)), for: .allEditingEvents)
    }
    
    @IBAction func send(_ sender: UIButton) {
        sender.animatePop { finished in
            if finished {
                self.sendDataToWS()
            }
        }
    }
    
    @objc private func didChangeCVVText(_ sender: UITextField) {
        cvvView.cvv = sender.text ?? ""
    }

    private func sendDataToWS() {
        
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

extension CVVViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let MAX_LENGTH = 3
        let updatedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return updatedString.count <= MAX_LENGTH
    }
}
