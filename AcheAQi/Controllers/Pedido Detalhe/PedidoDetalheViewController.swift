//
//  PedidoDetalheViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/02/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Karte

class PedidoDetalheViewController: UITableViewController {

    let itemCellID = "Produto Cell"
    let headerCellID = "Header Cell"
    let sectionCellID = "Section Cell"
    
    var pedido: Pedido! {
        didSet {
            itens = pedido.itens
        }
    }
    var itens: PedidoItens!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return itens.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let item = itens[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: itemCellID, for: indexPath) as! PedidoDetalheProdutoCell
            
            cell.item = item
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellID) as! PedidoDetalheHeader
            
            cell.pedido = pedido
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: sectionCellID) as! PedidoDetalheSectionCell
        
        let title = section == 0 ? String(format: "%@ #%d", "Resumo do pedido", pedido.id ?? "") : String(format: "%@ (%d)", "Produtos", itens.count)
        
        view.titleLabel.text = title
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38.0
    }
}

extension PedidoDetalheViewController: PedidoHeaderDelegate {
    func openMapRoute(empresa: Empresa) {
        let location = CLLocationCoordinate2D(latitude: empresa.latitude, longitude: empresa.longitude)
        
        let alert = Karte.createPicker(destination: location, title: "Selecione uma opção")
        
        present(alert, animated: true, completion: nil)
    }
    
    func openWhatsApp(empresa: Empresa) {
        let urlString = "whatsapp://send?text=Olá!&phone=" + empresa.whatsapp
        
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: urlStringEncoded!) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            AlertController.showAlert(message: "Não foi possível completar esta ação. Por favor, verifique se você possui o WhatsApp instalado no seu iPhone.")
        }
    }
    
    func callTel(empresa: Empresa) {
        let phone = empresa.telefone
        
        guard phone.isValid(regex: .phone) else {
            AlertController.showAlert(message: "Não foi possível fazer esta ligação. Por favor, tente novamente mais tarde.")
            return
        }
        
        phone.makeACall()
    }
}
