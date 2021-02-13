//
//  PedidoDetalheProdutoCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/02/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit
import AlamofireImage

class PedidoDetalheProdutoCell: UITableViewCell {

    @IBOutlet weak var produtoImageView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var qtdLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    
    var item: PedidoItem? {
        didSet {
            
            guard let item = self.item else { return }
            
            let produto = item.produto
            
            if let foto = produto.fotoPrincipal {
                produtoImageView.af_setImage(withURL: URL(wsURLWithPath: foto.path))
            }
            
            nomeLabel.text = produto.nome
            qtdLabel.text = String(item.qtd)
            valorLabel.text = (produto.valorAtual * Float(item.qtd)).toCurrency()
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
