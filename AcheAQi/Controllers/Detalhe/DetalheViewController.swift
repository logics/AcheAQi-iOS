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
    }
    
    @IBAction func openMap(_ sender: UIControl) {
        
    }
    
    @IBAction func openWhatsApp(_ sender: Any) {
    }
    
    @IBAction func call(_ sender: Any) {
    }
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
        
        imageTopConstraint.constant = currentTop
    }
}
