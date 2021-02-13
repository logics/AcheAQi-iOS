//
//  PedidoDetalheHeader.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/02/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit
import Spring

class PedidoDetalheHeader: UITableViewCell {

    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var taxaEntregaStackView: UIStackView!
    @IBOutlet weak var taxaLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var payIconImageView: UIImageView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var mapsBtnContainer: DesignableView!
    @IBOutlet weak var zapBtnContainer: DesignableView!
    @IBOutlet weak var telBtnContainer: DesignableView!

    var pedido: Pedido! {
        didSet {
            
            empresa = pedido.empresa
            
            empresaLabel.text = empresa?.nome
            dataLabel.text = pedido.createdAt?.formattedDateTime()
            valorLabel.text = pedido.valorTotal?.toCurrency()

            let status = pedido.statusInfo
            statusLabel.text = status.rawValue
            statusLabel.textColor = pedido.statusColor
            
            var deliveryText = "Retirar pessoalmente"
            var paymentText = "Dinheiro"
            var payIcon = UIImage(named: "money")
            
            if pedido.entrega, let endereco = pedido.endereco {
                let deliveryMethod = DeliveryMethod.from(endereco: endereco)
                deliveryText = deliveryMethod.description ?? deliveryText
            }
            
            if pedido.entrega, let taxaEntrega = pedido.taxaEntregaTotal {
                taxaLabel.text = taxaEntrega.toCurrency()
            } else {
                taxaEntregaStackView.removeFromSuperview()
            }
            
            if let cartao = pedido.cartao {
                let paymentMethod = PaymentMethod.from(cartao: cartao)
                paymentText = paymentMethod.title
                payIcon = paymentMethod.image
            }
            
            deliveryLabel.text = deliveryText
            paymentMethodLabel.text = paymentText
            payIconImageView.image = payIcon
        }
    }
    
    var empresa: Empresa?
    
    var delegate: PedidoHeaderDelegate?
    
    @IBAction func didTapRoute(_ sender: UIControl) {
        
        guard let empresa = self.empresa else { return }
        
        mapsBtnContainer.animation = "pop"
        
        mapsBtnContainer.animateNext {            
            self.delegate?.openMapRoute(empresa: empresa)
        }
    }
    
    @IBAction func didTapWhatsApp(_ sender: UIControl) {
        
        guard let empresa = self.empresa else { return }
        
        zapBtnContainer.animation = "pop"
        
        zapBtnContainer.animateNext {
            self.delegate?.openWhatsApp(empresa: empresa)
        }
    }
    
    @IBAction func didTapTel(_ sender: UIControl) {
        
        guard let empresa = self.empresa else { return }
        
        telBtnContainer.animation = "pop"
        
        telBtnContainer.animateNext {
            self.delegate?.callTel(empresa: empresa)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

protocol PedidoHeaderDelegate {
    func openMapRoute(empresa: Empresa)
    func openWhatsApp(empresa: Empresa)
    func callTel(empresa: Empresa)
}
