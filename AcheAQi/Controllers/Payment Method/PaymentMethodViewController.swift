//
//  PaymentMethodViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 13/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Alamofire

struct PaymentMethod {
    var cartao: Cartao?
    var title: String
    var image: UIImage
    
    static func from(cartaoData: Data) -> PaymentMethod {
        
        var paymentMethod: PaymentMethod!
        
        do {
            let card = try Cartao(data: cartaoData)
            
            paymentMethod = PaymentMethod.from(cartao: card)
        } catch {}
        
        return paymentMethod
    }
    
    static func from(cartao: Cartao) -> PaymentMethod {
                
        let cardType = CardType.fromString(cartao.brand.uppercased())
        let cardImage = cardType?.iconImage(colored: true) ?? UIImage(named: "cartaoGenerico")!
        
        let paymentMethod = PaymentMethod(cartao: cartao, title: cartao.maskedNumber(), image: cardImage)
        
        return paymentMethod
    }
    
    static func money() -> PaymentMethod {
        return PaymentMethod(cartao: nil, title: "Dinheiro", image: UIImage(named: "money")!)
    }
}

extension PaymentMethod: Equatable {
    static func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
        return (lhs.cartao == nil && rhs.cartao == nil) || (lhs.cartao?.id == rhs.cartao?.id)
    }
}

class PaymentMethodViewController: UIViewController {
    
    let sectionCellID = "Section Cell"
    let cellID = "Payment Cell"
    let segueShowFormCard = "Show Form Card Segue"
    let segueClose = "Close Segue"
    
    lazy var blurredView: UIView = {
        let blurredView = UIView(frame: self.view.bounds)
        blurredView.addBlur(radius: 15, from: navigationController!.view)
        
        return blurredView
    }()

    @IBOutlet weak var tableView: UITableView!
    
    var items: [PaymentMethod]!
    let dinheiroItem = PaymentMethod.money()
    
    var selectedItem: PaymentMethod!
    
    var delegate: PaymentMethodDelegate?
    
    var chooseToCart = true
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = chooseToCart ? [dinheiroItem] : []
        
        if selectedItem == nil {
            selectedItem = dinheiroItem
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = chooseToCart
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRemoteData()
    }
    
    // MARK: - Private Methods
    
    private func fetchRemoteData() {
        
        startAnimating()
        
        API.fetchCards { response in
            
            self.stopAnimating()
            
            self.items = self.chooseToCart ? [self.dinheiroItem] : []
            
            if let myCards = response.result.value {
                for card in myCards {
                    
                    let payMethod = PaymentMethod.from(cartao: card)
                    
                    self.items.append(payMethod)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func deleteCard(cartao: Cartao) {
        
        startAnimating()
        
        API.deleteCard(cartao: cartao) { response in
            self.stopAnimating()
            self.fetchRemoteData()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapAddButton(_ sender: Any) {
        
        navigationController?.view.addSubview(blurredView)

        self.blurredView.alpha = 0.0
        
        UIView.animate(withDuration: 0.3) {
            self.blurredView.alpha = 1.0
        } completion: { (finished) in
            if finished {
                self.performSegue(withIdentifier: self.segueShowFormCard, sender: sender)
            }
        }
    }
    
    @IBAction func unwindToPayMenthodViewController(_ unwindSegue: UIStoryboardSegue) {
        fetchRemoteData()
        
        UIView.animate(withDuration: 0.3) {
            self.blurredView.alpha = 0
        } completion: { (finished) in
            if finished {
                self.blurredView.removeFromSuperview()
            }
        }
    }
}

extension PaymentMethodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? PaymentMethodCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        cell.iconImageView.image = item.image
        cell.titleLabel.text = item.title
        cell.statusButton.isSelected = item == selectedItem
        cell.statusButton.isHidden = !chooseToCart
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return chooseToCart ? tableView.dequeueReusableCell(withIdentifier: sectionCellID) : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return chooseToCart ? 40.0 : 0
    }
    
    /// Selecting a item
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldSelectedIndexPath = tableView.indexPathForSelectedRow,
           let cell = tableView.cellForRow(at: oldSelectedIndexPath) as? PaymentMethodCell {
            cell.statusButton.isSelected = false
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodCell, chooseToCart {
            
            cell.statusButton.isSelected = true
            
            cell.animatePop(completionHandler: { finished in
                self.performSegue(withIdentifier: self.segueClose, sender: self)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let item = items[indexPath.row]
        
        return item.cartao != nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let item = items[indexPath.row]
            
            guard let cartao = item.cartao else { return }
            
            AlertController.showAlert(title: "Atenção!",
                                      message: "Você tem certeza que deseja deletar este cartão?",
                                      isConfirmStyled: true,
                                      confirmTitle: "Sim",
                                      okTitle: "Cancelar",
                                      confirmAction: {
                self.deleteCard(cartao: cartao)
                                      }, okAction: {})
        }
    }
}

protocol PaymentMethodDelegate {
    func didSetPaymentMethod(method: PaymentMethod) -> Void
}
