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
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let size = ProdutoCollectionViewCell.sizeForCell()
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        layoutIfNeeded()
    }
    
    static func sizeForCell() -> CGSize {
        
        let width = (UIScreen.main.bounds.size.width / 2) - 2
        let height = CGFloat(width * 1.3)

        return CGSize(width: width, height: height)
    }
}
