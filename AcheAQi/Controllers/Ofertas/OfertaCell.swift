//
//  OfertaCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 17/04/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import AlamofireImage

class OfertaCell: UITableViewCell {

    @IBOutlet weak var produtoImageView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var oldValueLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    var produto: Produto! {
        didSet {
            nomeLabel.text = produto.nome
            empresaLabel.text = String(format: "Por: %@", produto.empresa.nome)
            oldValueLabel.text = String(format: "De: %@ por:", produto.valor.toCurrency() ?? "--")
            valueLabel.text = produto.valorPromocional?.toCurrency() ?? ""
            percentLabel.text = String(format: "%@%@", produto.percClean, "% OFF")
            
            if let path = produto.fotos.first?.path {
                self.produtoImageView.af_setImage(withURL: URL(wsURLWithPath: path), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        produtoImageView.image = #imageLiteral(resourceName: "Placeholder.pdf")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
