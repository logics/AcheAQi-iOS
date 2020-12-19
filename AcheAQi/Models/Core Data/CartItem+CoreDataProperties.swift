//
//  CartItem+CoreDataProperties.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 12/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var addedAt: Date?
    @NSManaged public var produto: Data?
    @NSManaged public var produtoId: Int16
    @NSManaged public var qtd: Int16
    @NSManaged public var valorUnitario: Float
    @NSManaged public var cart: Cart?

}
