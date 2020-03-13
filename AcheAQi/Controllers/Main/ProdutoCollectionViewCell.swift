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
    
    static var width = (UIScreen.main.bounds.size.width / 2) - 1
    
    lazy var widthConstraint: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: ProdutoCollectionViewCell.width)
        width.isActive = true
        return width
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutIfNeeded()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        widthConstraint.constant = ProdutoCollectionViewCell.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: (ProdutoCollectionViewCell.width * 1.2)))
    }
}
