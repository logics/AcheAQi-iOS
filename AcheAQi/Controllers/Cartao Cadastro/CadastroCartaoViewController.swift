//
//  CadastroCartaoViewController.swift
//  SabbePay
//
//  Created by Romeu Godoi on 08/01/19.
//  Copyright © 2019 Logics Software. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import CoreData
import Spring

private let segueShowForm = "Show Form Segue"
private let segueClose = "Close Segue"

class CadastroCartaoViewController: UIViewController {

    @IBOutlet weak var centerView: DesignableView!

    var formVC: FormCartaoTableViewController!
    var empresa: Empresa!
    var cartao: Cartao?

    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    @IBAction func hideKeyboard(_ sender: Any) {
        formVC.currentResponder?.resignFirstResponder()
    }
    
    @IBAction func saveCard(_ sender: Any) {
        guard let brand = formVC.brand else {
            AlertController.showAlert(title: "Ops!", message: "Cartão/bandeira inválido(a).")
            return
        }
        guard let nome = formVC.nomeTextField.text else {
            AlertController.showAlert(title: "Ops!", message: "Por favor informe o nome impresso no cartão.")
            return
        }
        guard let validade = formVC.validadeTextField.text else {
            AlertController.showAlert(title: "Ops!", message: "Por favor informe a validade do cartão.")
            return
        }
        guard let cvv = formVC.cvvTextField.text else {
            AlertController.showAlert(title: "Ops!", message: "Por favor informe o código (CVV) que fica no verso do cartão.")
            return
        }

        let nrCard = formVC.nrCartaoTextField.text!.replacingOccurrences(of: " ", with: "")
        
        let params: [String: Any] = [
            "cardNumber": nrCard,
            "holder": nome.trimmingCharacters(in: .whitespacesAndNewlines),
            "expirationDate": validade,
            "brand": brand,
            "cardType": formVC.cardTypeString ?? "",
            "cvv": cvv,
            "isDefault": formVC.isDefaultSwich.isOn
        ]
        
        startAnimating()
        
        let url = API.baseURL + "/cartoes/tokenize"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseModel { (response: DataResponse<Cartao>) in
            self.stopAnimating()
            
            switch response.result {
            case .success(let cartao):
                
                self.cartao = cartao
                
                self.performSegue(withIdentifier: segueClose, sender: self)
                
            case .failure(let error):
                AlertController.showAlert(title: "Ops!", message: response.errorMessage ?? "Não foi possível processar a operação. Tente novamente mais tarde.")
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowForm {
            formVC = segue.destination as? FormCartaoTableViewController
        }
    }
}
