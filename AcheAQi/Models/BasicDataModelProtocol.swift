//
//  BasicDataModelProtocol.swift
//  Aser RMS
//
//  Created by Romeu Godoi on 29/08/17.
//  Copyright © 2017 Aser Security. All rights reserved.
//

import Foundation
import CoreData

@objc protocol BasicDataModelProtocol {
    @objc optional var externalID: NSNumber? { get }
    @objc optional var title: String { get }
}

protocol UpdatableDataModel: NSFetchRequestResult {
    var updatedAt: NSDate? { get }
}

//protocol UpdatableUserDataModel: UpdatableDataModel {
//    var updatedAt: NSDate? { get }
//    static func predicateOfSync(of user: Usuario) -> NSPredicate?
//}
