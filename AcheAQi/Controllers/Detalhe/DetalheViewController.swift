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
import CoreData

class DetalheViewController: UIViewController {

    @IBOutlet weak var headerFotos: DesignableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fotosScrollView: UIScrollView!
    @IBOutlet weak var fotosPageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var marcaLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var nomeProdutoLabel: UILabel!
    @IBOutlet weak var oldValueLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var percLabel: UILabel!
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
    @IBOutlet weak var fotosStackView: UIStackView!
    @IBOutlet weak var qtdTextField: UITextField!
    
    var originalImageHeight: CGFloat!
    var produto: Produto! {
        didSet {
            self.empresa = produto.empresa
        }
    }
    var empresa: Empresa!
    var userLocation: CLLocationCoordinate2D?
    var qtd = 1 {
        didSet {
            qtdTextField.text = String(qtd)
        }
    }
    
    private lazy var moc: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()


    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImageHeight = imageHeightConstraint.constant
        scrollView.delegate = self
        
        setupViews()
    }

    // MARK: - Private Functions
    
    fileprivate func setupViews() {
        
        setupFotos()

        title = produto.nome
        nomeProdutoLabel.text = produto.nome
        marcaLabel.text = produto.marca?.nome ?? "--"
        oldValueLabel.text = String(format: "De: %@ por:", produto.valor.toCurrency() ?? "--")
        valorLabel.text = produto.valorAtual.toCurrency()
        percLabel.text = String(format: "%@%@", produto.percClean, "% OFF")
        disponivelLabel.text = produto.emEstoque ? "Estoque disponível" : "Indisponível"
        empresaLabel.text = empresa.nome
        enderecoLabel.text = empresa.enderecoCompleto()
        descricaoLabel.text = produto.descricao
        
        if !produto.emPromocao {
            oldValueLabel.removeFromSuperview()
            percLabel.removeFromSuperview()
        }
    }
    
    fileprivate func setupFotos() {
        imageView.removeFromSuperview()
        
        for foto in produto.fotos {
            let fotoImgView = fotoImageView(with: foto)
            
            fotosStackView.addArrangedSubview(fotoImgView)
            
            fotoImgView.widthAnchor.constraint(equalTo: headerFotos.widthAnchor, multiplier: 1).isActive = true
            fotoImgView.heightAnchor.constraint(equalTo: headerFotos.heightAnchor, multiplier: 1).isActive = true
        }
        
        fotosPageControl.numberOfPages = produto.fotos.count
        fotosPageControl.currentPage = 0
        
        fotosScrollView.delegate = self
    }
    
    fileprivate func fotoImageView(with foto: Foto) -> UIImageView {
        
        let imgV = UIImageView(frame: headerFotos.frame)
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .scaleAspectFit
        imgV.clipsToBounds = true
        imgV.af_setImage(withURL: URL(wsURLWithPath: foto.path), placeholderImage: #imageLiteral(resourceName: "Placeholder.pdf"))

        return imgV
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
    
    @IBAction func increaseQtd(_ sender: Any) {
        qtd += 1
    }
    
    @IBAction func decreaseQtd(_ sender: Any) {
        if qtd > 1 {
            qtd += 1
        }
    }
    
    @IBAction func addToCart(_ sender: DesignableButton) {
        sender.animatePop { success in
            if success {
                CartViewController.addProdutoToCart(produto: self.produto, qtd: self.qtd, context: self.moc)
            }
        }
    }
    
    @IBAction func buyNow(_ sender: DesignableButton) {
        CartViewController.addProdutoToCart(produto: produto, qtd: qtd, context: moc) {
            sender.animatePop { success in
                if success {
                    let cartSb = UIStoryboard(name: "Carrinho", bundle: nil)
                    
                    if let vc = cartSb.instantiateInitialViewController() {
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension DetalheViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollView {
            
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
        else if scrollView == self.fotosScrollView {
            let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
            fotosPageControl.currentPage = Int(pageIndex)
        }
    }
}
