//
//  ProdutoCollectionViewCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 17/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import AlamofireImage

class ProdutoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var percView: CustomView!
    @IBOutlet weak var percLabel: UILabel!
    
    var produto: Produto! {
        didSet {
            valorLabel.text = produto.valorAtual.toCurrency() ?? "R$ --,--"
            nomeLabel.text = produto.nome
            empresaLabel.text = String(format: "Por: %@", produto.empresa.nome)
            percLabel.text = String(format: "%@%@", produto.percClean, "% OFF")
            
            percView.isHidden = !produto.emPromocao
            
            nomeLabel.sizeToFit()

            if let path = produto.fotos.first?.path {
                self.imageView.af_setImage(withURL: URL(wsURLWithPath: path), placeholderImage: #imageLiteral(resourceName: "Placeholder"), imageTransition: .crossDissolve(0.2))
            }
        }
    }
    
    static var width = (UIScreen.main.bounds.size.width / 2) - 1
    
    lazy var widthConstraint: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: ProdutoCollectionViewCell.width)
        width.isActive = true
        return width
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.image = #imageLiteral(resourceName: "Placeholder")

        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = #imageLiteral(resourceName: "Placeholder")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        widthConstraint.constant = ProdutoCollectionViewCell.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: (ProdutoCollectionViewCell.width * 1.8)))
    }
}
