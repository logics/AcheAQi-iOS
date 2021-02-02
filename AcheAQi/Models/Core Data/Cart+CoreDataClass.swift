//
//  Cart+CoreDataClass.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 10/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Cart)
public class Cart: NSManagedObject {
    
    static func findPendingOrCreate(compraDireta: Bool = false, context: NSManagedObjectContext) -> Cart {
        
        if let cart = Cart.findPending(compraDireta: compraDireta, context: context) {
            return cart
        } else {
            
            let cart = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: context) as! Cart
            
            cart.createdAt = Date()
            cart.formaPagamento = FormaPagamento.dinheiro.rawValue
            cart.entrega = false
            cart.compraDireta = compraDireta
            
            context.saveObject()
            
            return cart
        }
    }
    
    static func findPending(compraDireta: Bool = false, context: NSManagedObjectContext) -> Cart? {
        
        let request: NSFetchRequest<Cart> = Cart.fetchRequest()
        request.predicate = NSPredicate(format: "compraDireta = %@", NSNumber(value: compraDireta))
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            
            return results.first
        } catch {
            fatalError()
        }
    }

    func contains(produtoId: Int, context: NSManagedObjectContext) -> Bool {
        guard let items = self.items?.allObjects as? [CartItem] else { return false }
        
        return items.contains { item -> Bool in
            return item.produtoId == produtoId
        }
    }
    
    func asPedido() -> Pedido {
        
        /// Pedido
        let pedido = Pedido(formaPagamento: formaPagamento!, entrega: entrega)
        
        /// Items
        var pedidoItems = PedidoItens()
        
        if let items = items as? Set<CartItem> {
        
            items.forEach({ (item: CartItem) in
                
                do {
                    if let prodData = item.produto {
                        
                        let produto = try Produto(data: prodData)
                                
                        let pedidoItem = PedidoItem(produto: produto,
                                                    qtd: Int(item.qtd),
                                                    valorUnitario: item.valorUnitario,
                                                    pedido: pedido)
                        
                        pedidoItems.append(pedidoItem)
                    }
                } catch {
                    fatalError()
                }
            })
        }
        pedido.itens = pedidoItems
        
        /// Pagamento em Cartão
        if let cardData = cartao {
            do {
                let cartao = try Cartao(data: cardData)
                pedido.cartao = cartao
            } catch {
                fatalError()
            }
        }
        
        if let endData = endereco {
            do {
                let endereco = try Endereco(data: endData)
                pedido.endereco = endereco
            } catch {
                fatalError()
            }
        }
        
        return pedido
    }
}
