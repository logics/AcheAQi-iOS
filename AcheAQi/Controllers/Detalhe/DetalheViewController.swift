//
//  DetalheViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 09/03/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class DetalheViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var nomeProdutoLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var showMapaButton: UIControl!
    @IBOutlet weak var whatsAppButton: UIControl!
    @IBOutlet weak var telButton: UIControl!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var originalImageHeight: CGFloat!
    
    // MARK: VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImageHeight = imageHeightConstraint.constant
        scrollView.delegate = self
        
        
//        showMapaButton.imageView.image = UIImage(systemName: "mappin.and.ellipse")
//        whatsAppButton.imageView.image = UIImage(systemName: "mappin.and.ellipse")
//        telButton.imageView.image = UIImage(systemName: "phone.fill.arrow.up.right")
//
//        showMapaButton.label.text = "Como chegar"
//        whatsAppButton.label.text = "Entre no chat"
//        telButton.label.text = "Ligar"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descricaoLabel.sizeToFit()
    }
    
    @IBAction func openMap(_ sender: Any) {
    }
    
    @IBAction func openWhatsApp(_ sender: Any) {
    }
    
    @IBAction func call(_ sender: Any) {
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

extension DetalheViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y

        let defaultTop = CGFloat(0)

        // If we have not scrolled too high then stick to default y pos
        var currentTop = defaultTop

        if offset < 0 { // Whenever we go too high run this code block

            // The new top (y position) of the imageview
            currentTop = offset

            imageHeightConstraint.constant = originalImageHeight - offset
        } else {
            imageHeightConstraint.constant = originalImageHeight
        }
        
        print(currentTop)
        
//        imageTopConstraint.constant = currentTop
    }
}
