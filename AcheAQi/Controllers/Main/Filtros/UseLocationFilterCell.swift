//
//  UseLocationFilterCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 28/02/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit

class UseLocationFilterCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var useLocation: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
