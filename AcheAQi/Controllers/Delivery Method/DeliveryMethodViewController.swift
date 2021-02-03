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
    let detalheCellID = "Detalhe Cell"
    let segueShowFormCard = "Show Form Segue"
    let segueClose = "Close Segue"

    @IBOutlet weak var tableView: UITableView!
    
    var items: [DeliveryMethod]!
    let pessoalmenteItem = DeliveryMethod.retirarPessoalmente()
    
    var selectedItem: DeliveryMethod!
    
    var delegate: DeliveryMethodDelegate?
    
    var chooseToCart = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = chooseToCart ? [pessoalmenteItem] : []
        
        if selectedItem == nil, chooseToCart {
            selectedItem = pessoalmenteItem
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        title = chooseToCart ? "Forma de Entrega" : "Endereços de Entrega"
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
            
            self.items = self.chooseToCart ? [self.pessoalmenteItem] : []
            
            if let enderecos = response.result.value {
                for endereco in enderecos {
                    
                    let deliveryMethod = DeliveryMethod.from(endereco: endereco)
                    
                    self.items.append(deliveryMethod)
                }
            }
            
            self.tableView.reloadData()
        }
    }
        
    private func deleteAddress(id: Int) {
        
        startAnimating()
        
        API.deleteAddress(id: id) { response in
            self.stopAnimating()
            self.fetchRemoteData()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func unwindToPayMenthodViewController(_ unwindSegue: UIStoryboardSegue) {
        fetchRemoteData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowFormCard,
           !chooseToCart,
           let address = self.selectedItem.endereco,
           let vc = segue.destination as? EnderecoFormViewController {
            vc.endereco = address
        }
    }
}

extension DeliveryMethodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = items[indexPath.row]

        let cellID = item.endereco == nil ? personalCellID : (chooseToCart ? addressCellID : detalheCellID)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? DeliveryMethodCell else { return UITableViewCell() }
        
        if cellID != detalheCellID {
            cell.titleLabel.text = item.title
            cell.statusButton.isSelected = item == selectedItem
        }

        // Implementar depois
        cell.statusButton.isHidden = !chooseToCart

        if cell.reuseIdentifier == addressCellID || cell.reuseIdentifier == detalheCellID {
            cell.descriptionLabel.text = item.description
        }
        
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
           let cell = tableView.cellForRow(at: oldSelectedIndexPath) as? DeliveryMethodCell {
            cell.statusButton.isSelected = false
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        self.delegate?.didSetDeliveryMethod(method: selectedItem)
        
        if let cell = tableView.cellForRow(at: indexPath) as? DeliveryMethodCell {

            cell.statusButton.isSelected = true
            
            cell.animatePop { finished in
                let segue = self.chooseToCart ? self.segueClose : self.segueShowFormCard
                self.performSegue(withIdentifier: segue, sender: self)
            }
        }
    }
    
    /// Editando / Deletando item
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let item = items[indexPath.row]
        
        return item.endereco != nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = items[indexPath.row]
            
            guard let endereco = item.endereco, let id = endereco.id else { return }
            
            AlertController.showAlert(title: "Atenção!",
                                      message: "Você tem certeza que deseja deletar este endereço?",
                                      isConfirmStyled: true,
                                      confirmTitle: "Sim",
                                      okTitle: "Cancelar",
                                      confirmAction: {
                                        self.deleteAddress(id: id)
                                      }, okAction: {})

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
        
        let description = String(format: "%@, %@ %@ %@ %@ - %@",
                                 endereco.logradouro,
                                 endereco.numero != nil ? endereco.numero! : "",
                                 endereco.complemento != nil ? endereco.complemento! : "",
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
