//
//  DeliveryMethodViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 29/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Alamofire

class DeliveryMethodViewController: UIViewController {

    let sectionCellID = "Section Cell"
    let personalCellID = "Retirar Pessoalmente Cell"
    let addressCellID = "Delivery Method Cell"
    let segueShowFormCard = "Show Form Segue"
    let segueClose = "Close Segue"

    @IBOutlet weak var tableView: UITableView!
    
    var items: [DeliveryMethod]!
    let pessoalmenteItem = DeliveryMethod.retirarPessoalmente()
    
    var selectedItem: DeliveryMethod!
    
    var delegate: DeliveryMethodDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [pessoalmenteItem]
        
        if selectedItem == nil {
            selectedItem = pessoalmenteItem
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRemoteData()
    }
    
    // MARK: - Private Methods
    
    private func fetchRemoteData() {
        
        startAnimating()
        
        API.fetchModel { (response: DataResponse<Enderecos>) in
            
            self.stopAnimating()
            
            self.items = [self.pessoalmenteItem]
            
            if let enderecos = response.result.value {
                for endereco in enderecos {
                    
                    let deliveryMethod = DeliveryMethod.from(endereco: endereco)
                    
                    self.items.append(deliveryMethod)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapAddButton(_ sender: Any) {
        
//        navigationController?.view.addSubview(blurredView)
        
//        UIView.animate(withDuration: 0.3) {
//            self.blurredView.blurRadius = 20
//        } completion: { (finished) in
//            if finished {
//                self.performSegue(withIdentifier: self.segueShowFormCard, sender: sender)
//            }
//        }
    }
    
    @IBAction func unwindToPayMenthodViewController(_ unwindSegue: UIStoryboardSegue) {
        fetchRemoteData()
        
//        UIView.animate(withDuration: 0.3) {
//            self.blurredView.blurRadius = 0
//        } completion: { (finished) in
//            if finished {
//                self.blurredView.removeFromSuperview()
//            }
//        }
    }
}

extension DeliveryMethodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = items[indexPath.row]

        let cellID = item.endereco == nil ? personalCellID : addressCellID
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? DeliveryMethodCell else { return UITableViewCell() }
        
        cell.titleLabel.text = item.title
        cell.statusButton.isSelected = item == selectedItem

        if cell.reuseIdentifier == addressCellID {
            cell.descriptionLabel.text = item.description
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: sectionCellID)
    }
    
    /// Selecting a item
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldSelectedIndexPath = tableView.indexPathForSelectedRow,
           let cell = tableView.cellForRow(at: oldSelectedIndexPath) as? DeliveryMethodCell {
            cell.statusButton.isSelected = false
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        self.delegate?.didSetDeliveryMethod(method: selectedItem)
        
        if let cell = tableView.cellForRow(at: indexPath) as? DeliveryMethodCell {
            cell.animatePop { finished in
                self.performSegue(withIdentifier: self.segueClose, sender: self)
            }
            cell.statusButton.isSelected = true
        }
    }
}

struct DeliveryMethod: Equatable {
    var endereco: Endereco?
    var title: String
    var description: String?

    static func from(enderecoData: Data) -> DeliveryMethod {
        var deliveryMethod: DeliveryMethod!
        
        do {
            let endereco = try Endereco(data: enderecoData)
            
            deliveryMethod = DeliveryMethod.from(endereco: endereco)
        } catch {}
        
        return deliveryMethod
    }
    
    static func from(endereco: Endereco) -> DeliveryMethod {
        
        let description = String(format: "%@, %@ %@, %@ - %@",
                                 endereco.logradouro,
                                 endereco.numero != nil ? endereco.numero! + "," : "",
                                 endereco.bairro,
                                 endereco.cidade,
                                 endereco.estado)
        
        return DeliveryMethod(endereco: endereco,
                              title: "Receber no endereço abaixo",
                              description: description)
    }
    
    static func retirarPessoalmente() -> DeliveryMethod {
        let desc = "Retirar pessoalmente no local"
        return DeliveryMethod(endereco: nil, title: desc, description: desc)
    }
    
    static func == (lhs: DeliveryMethod, rhs: DeliveryMethod) -> Bool {
        return (lhs.endereco == nil && rhs.endereco == nil) || (lhs.endereco?.id == rhs.endereco?.id)
    }
}

protocol DeliveryMethodDelegate {
    func didSetDeliveryMethod(method: DeliveryMethod) -> Void
}
