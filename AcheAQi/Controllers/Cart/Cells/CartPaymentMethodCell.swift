//
//  CartPayShippingCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 16/11/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class CartPaymentMethodCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var cart: Cart! {
        didSet {
            
            var cartao: Cartao?
            
            if let cardData = cart.cartao {
                do {
                    try cartao = Cartao(data: cardData)
                } catch {}
            }
            
            titleLabel.text = cart.formaPagamento == FormaPagamento.cartao.rawValue ?
                cartao?.maskedNumber() :
                "Dinheiro"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
