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
    
    static func findPendingOrCreate(context: NSManagedObjectContext) -> Cart {
        
        if let cart = Cart.findPending(context: context) {
            return cart
        } else {
            
            let cart = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: context) as! Cart
            
            cart.createdAt = Date()
            cart.entrega = false
            
            context.saveObject()
            
            return cart
        }
    }
    
    static func findPending(context: NSManagedObjectContext) -> Cart? {
        
        let request: NSFetchRequest<Cart> = Cart.fetchRequest()
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
}
