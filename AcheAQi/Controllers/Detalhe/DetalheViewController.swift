//
//  DetalheViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 09/03/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MaterialDesignWidgets
import Spring
import Karte

class DetalheViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var nomeProdutoLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var disponivelLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var showMapaButton: UIControl!
    @IBOutlet weak var whatsAppButton: UIControl!
    @IBOutlet weak var telButton: UIControl!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapsBtnContainer: DesignableView!
    @IBOutlet weak var zapBtnContainer: DesignableView!
    @IBOutlet weak var telBtnContainer: DesignableView!
    
    var originalImageHeight: CGFloat!
    var produto: Produto! {
        didSet {
            self.empresa = produto.empresa
        }
    }
    var empresa: Empresa!
    var userLocation: CLLocationCoordinate2D?

    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImageHeight = imageHeightConstraint.constant
        scrollView.delegate = self
        
        setupViews()
    }
    
    // MARK: - Private Functions
    
    fileprivate func setupViews() {
        
        imageView.af_setImage(withURL: URL(wsURLWithPath: produto.foto), placeholderImage: #imageLiteral(resourceName: "Placeholder.pdf"))
        title = produto.nome
        nomeProdutoLabel.text = produto.nome
        valorLabel.text = produto.valor.toCurrency()
        disponivelLabel.text = produto.emEstoque ? "Estoque disponível" : "Indisponível"
        empresaLabel.text = empresa.nome
        enderecoLabel.text = empresa.enderecoCompleto()
        descricaoLabel.text = produto.descricao
    }
    
    // MARK: - IBActions
    
    @IBAction func openMap(_ sender: UIControl) {
        mapsBtnContainer.animation = "pop"
        
        mapsBtnContainer.animateNext {
            let location = CLLocationCoordinate2D(latitude: self.empresa.latitude, longitude: self.empresa.longitude)
            
            let alert = Karte.createPicker(destination: location, title: "Selecione uma opção")
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openWhatsApp(_ sender: Any) {
        zapBtnContainer.animation = "pop"
        
        zapBtnContainer.animateNext {
            let urlString = "whatsapp://send?text=Olá!&phone=" + self.empresa.whatsapp

            let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let url = URL(string: urlStringEncoded!) else { return }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                AlertController.showAlert(message: "Não foi possível completar esta ação. Por favor, verifique se você possui o WhatsApp instalado no seu iPhone.")
            }
        }
    }
    
    @IBAction func call(_ sender: Any) {
        telBtnContainer.animation = "pop"
        
        telBtnContainer.animateNext {
            let phone = self.empresa.telefone
            
            guard phone.isValid(regex: .phone) else {
                AlertController.showAlert(message: "Não foi possível fazer esta ligação. Por favor, tente novamente mais tarde.")
                return
            }
            
            phone.makeACall()
        }
    }
}

// MARK: - UIScrollViewDelegate
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