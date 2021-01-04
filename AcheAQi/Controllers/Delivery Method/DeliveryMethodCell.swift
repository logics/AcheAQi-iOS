//
//  DeliveryMethodCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 29/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class DeliveryMethodCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
