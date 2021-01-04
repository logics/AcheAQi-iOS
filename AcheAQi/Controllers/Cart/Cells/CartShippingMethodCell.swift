//
//  CartShippingMethodCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 09/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class CartShippingMethodCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var deliveryMethod: DeliveryMethod! {
        didSet {
            titleLabel.text = deliveryMethod.description
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
