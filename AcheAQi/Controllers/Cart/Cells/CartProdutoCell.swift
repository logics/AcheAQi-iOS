//
//  CartProdutoCell.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 16/11/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

class CartProdutoCell: UITableViewCell {

    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var qtdTextField: UITextField!
    @IBOutlet weak var valorLabel: UILabel!
    
    var delegate: CartItemDeletable!
    var produto: Produto!
    
    var item: CartItem! {
        didSet {
            if let produtoData = item.produto {
                do {
                    produto = try Produto(data: produtoData)
                } catch {
                    fatalError()
                }
                
                if let foto = produto.fotoPrincipal {
                    fotoImageView.af_setImage(withURL: URL(wsURLWithPath: foto.path))
                }
                
                nomeLabel.text = produto.nome
                qtdTextField.text = String(item.qtd)
                valorLabel.text = (produto.valorAtual * Float(item.qtd)).toCurrency()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func excluir(_ sender: Any) {
        delegate.deleteCartItem(id: item.objectID)
    }
    
    @IBAction func increase(_ sender: Any) {
        item.increase()
    }
    
    @IBAction func decrease(_ sender: Any) {
        item.decrease()
    }
}

protocol CartItemDeletable {
    func deleteCartItem(id: NSManagedObjectID) -> Void
}
