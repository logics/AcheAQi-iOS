//
//  PedidoTableViewCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 05/02/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit

class PedidoTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var pedido: Pedido? {
        didSet {
            nomeLabel.text = pedido?.empresa?.nome
            dataLabel.text = pedido?.createdAt?.formattedDateTime()
            valorLabel.text = pedido?.valorTotal?.toCurrency()
            
            let status = pedido?.statusInfo
            statusLabel.text = status?.rawValue
            statusLabel.textColor = pedido?.statusColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
