//
//  PaymentMethodViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 13/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import DynamicBlurView

struct PaymentMethod {
    let cartao: Cartao?
    let title: String
    let image: UIImage
}

class PaymentMethodViewController: UIViewController {
    
    let sectionCellID = "Section Cell"
    let cellID = "Payment Cell"
    let segueShowFormCard = "Show Form Card Segue"
    
    lazy var blurredView: DynamicBlurView = {
        let blurredView = DynamicBlurView(frame: self.view.bounds)
        
        return blurredView
    }()

    @IBOutlet weak var tableView: UITableView!
    
    var items: [PaymentMethod]!
    let dinheiroItem: PaymentMethod = PaymentMethod(cartao: nil, title: "Dinheiro", image: UIImage(named: "money")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [dinheiroItem]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRemoteData()
    }
    
    private func fetchRemoteData() {
        
        startAnimating()
        
        API.fetchCards { response in
            
            self.stopAnimating()
            
            self.items = [self.dinheiroItem]
            
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
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        
        navigationController?.view.addSubview(blurredView)

        UIView.animate(withDuration: 0.3) {
            self.blurredView.blurRadius = 20
        } completion: { (finished) in
            if finished {
                self.performSegue(withIdentifier: self.segueShowFormCard, sender: sender)
            }
        }
    }
    
    @IBAction func unwindToPayMenthodViewController(_ unwindSegue: UIStoryboardSegue) {
        fetchRemoteData()
        
        UIView.animate(withDuration: 0.3) {
            self.blurredView.blurRadius = 0
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
        cell.statusButton.isSelected = item.title == "Dinheiro"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: sectionCellID)
    }
    
}
