//
//  CartItem+CoreDataClass.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 16/11/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CartItem)
public class CartItem: NSManagedObject {

    func increase() {
        qtd += 1
        
        guard let moc = managedObjectContext else { return }
        
        do {
            try moc.save()
        } catch {
            fatalError()
        }
    }
    
    func decrease() {
        guard qtd > 1 else { return }
        guard let moc = managedObjectContext else { return }

        qtd -= 1
        
        do {
            try moc.save()
        } catch {
            fatalError()
        }
    }
}
