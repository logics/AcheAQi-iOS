//
//  LoadingCollectionViewCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 25/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    public static var cellID = "Loading Cell"
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        return contentView.systemLayoutSizeFitting(CGSize(width: UIScreen.main.bounds.size.width,
                                                          height: 55.0),
                                                   withHorizontalFittingPriority: horizontalFittingPriority,
                                                   verticalFittingPriority: verticalFittingPriority)
    }
}
