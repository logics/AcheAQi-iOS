//
//  PaymentMethodViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 13/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

struct PaymentMethod {
    let cartao: Cartao?
    let title: String
    let image: UIImage
}

class PaymentMethodViewController: UIViewController {
    
    let sectionCellID = "Section Cell"
    let cellID = "Payment Cell"
    let addCardCellID = "Add Card Cell"

    @IBOutlet weak var tableView: UITableView!
    
    var items: [PaymentMethod]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let din = PaymentMethod(cartao: nil, title: "Dinheiro", image: UIImage(named: "money")!)
        let card = PaymentMethod(cartao: nil, title: "XXXX - XXXX - XXXX - 8922", image: UIImage(named: "mastercardOn")!)
        
        items = [din, card]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        startAnimating()
        
        API.fetchCards { response in
            
            self.stopAnimating()
            
            self.items = [din]
            
            if let myCards = response.result.value {
                for card in myCards {
                    
                    let cardType = CardType.fromString(card.brand.uppercased())
                    
                    let cardImage = cardType?.iconImage(colored: true) ?? UIImage(named: "cartaoGenerico")!
                    
                    let payMethod = PaymentMethod(cartao: card, title: card.maskedNumber(), image: cardImage)
                    
                    self.items.append(payMethod)
                }
            }
            
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
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
        cell.statusButton.isSelected = item.title == "Dinheiro"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: sectionCellID)
    }
    
}
