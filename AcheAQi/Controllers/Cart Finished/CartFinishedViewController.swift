//
//  CartFinishedViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/01/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit

class CartFinishedViewController: UIViewController {

    @IBOutlet weak var nrPedidoLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    
    var pedido: Pedido!
    var pagamento: Pagamento!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        nrPedidoLabel.text = String(pedido.id!)
        dataLabel.text = pedido.createdAt?.formattedDate(dateFormat: "dd/MM/yyyy HH:mm:ss")
        paymentMethodLabel.text = pedido.formaPagamento.capitalizingFirstLetter()
        
        var enderecoDescription = DeliveryMethod.retirarPessoalmente().description
        
        if pedido.entrega, let enderecoEntrega = pedido.endereco {
            enderecoDescription = DeliveryMethod.from(endereco: enderecoEntrega).description
        }
        
        deliveryMethodLabel.text = enderecoDescription
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
