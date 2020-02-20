//
//  ProdutoCollectionViewCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 17/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class ProdutoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: (screenWidth / 2) - 2).isActive = true
    }
}
