//
//  Cart+CoreDataProperties.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 12/01/21.
//  Copyright © 2021 Logics Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var cartao: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var endereco: Data?
    @NSManaged public var entrega: Bool
    @NSManaged public var formaPagamento: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Cart {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: CartItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: CartItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
