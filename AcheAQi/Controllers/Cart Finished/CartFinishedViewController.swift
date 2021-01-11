//
//  CartFinishedViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/01/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//

import UIKit

class CartFinishedViewController: UIViewController {

    @IBOutlet weak var nrPedidoLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
