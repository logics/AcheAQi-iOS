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
import CoreData
import Alamofire

class CVVViewController: UIViewController {
    
    let segueShowFinished = "Show Cart Finished Segue"

    @IBOutlet weak var cvvView: CVVCardView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var cvvTextField: DesignableTextField!
    @IBOutlet weak var sendButton: DesignableButton!
    
    var cart: Cart!
    var cartao: Cartao!
    var pagamento: Pagamento?
    var pedido: Pedido?
    
    private lazy var moc: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        cvvTextField.addTarget(self, action: #selector(didChangeCVVText(_:)), for: .allEditingEvents)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cvvTextField.becomeFirstResponder()
    }
    
    @IBAction func send(_ sender: UIButton) {
        sender.animatePop { finished in
            if finished {
                self.sendDataToWS()
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        UIApplication.shared.resignCurrentResponder()
    }
    
    @objc private func didChangeCVVText(_ sender: UITextField) {
        cvvView.cvv = sender.text ?? ""
    }
    
    private func setupViews() {
        cvvView.cardNumber = cartao.maskedNumber()
        cvvView.titular = cartao.titular

        switch CardType.fromString(cartao.brand.uppercased()) {
            case .amex:
                brandImageView.image = UIImage(named: "amex-logo-gray")
            case .diners:
                brandImageView.image = UIImage(named: "diners-club-logo-gray")
            case .masterCard:
                brandImageView.image = UIImage(named: "mastercard-gray")
            case .visa:
                brandImageView.image = UIImage(named: "visa-logo-gray")
            default:
                brandImageView.image = nil
                brandImageView.isHidden = true
        }
    }

    private func sendDataToWS() {
        cvvTextField.resignFirstResponder()
        
        guard let cvvText = cvvTextField.text?.trimmingCharacters(in: .whitespaces), cvvText.length == 3, let cvv = Int(cvvText) else {
            AlertController.showAlert(message: "Por favor informe o Codigo de Segurança do cartão.", okAction: {
                self.cvvTextField.becomeFirstResponder()
            })
            return
        }
        
        self.processPaymentWS(pedido: cart.asPedido(), empresaId: cart.empresaId, cvv: cvv)
    }
    
    private func processPaymentWS(pedido: Pedido, empresaId: Int16, cvv: Int) {
        
        self.startAnimating(message: "Processando pagamento...")
        
        /// Processando pagamento
        API.processPayment(pedido: pedido, empresaId: empresaId, cvv: cvv) { (response: DataResponse<Pagamento>) in
            
            self.stopAnimating()
            
            guard let pag = response.result.value else {
                let msg = response.errorMessage ?? "Não conseguimos processar o seu pagamento. Por favor entre em contato com a nossa central de atendimento."
                AlertController.showAlert(message: msg)
                return
            }
            
            self.pagamento = pag
            
            self.performSegue(withIdentifier: self.segueShowFinished, sender: self)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CartFinishedViewController {

            vc.pedido = pagamento!.pedido
            
            self.moc.delete(cart)
            self.moc.saveObject()
        }
    }
}

extension CVVViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let MAX_LENGTH = 3
        let updatedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return updatedString.count <= MAX_LENGTH
    }
}
