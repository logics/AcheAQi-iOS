//
//  NSmanagedObjectContext+Convenience.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 11/12/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveObject() {
        if self.hasChanges {
            do {
                try self.save()
            } catch(let error) {
                debugPrint("An error ocurred when trying to save changes on Core Data. Error: \(error)")
            }
        }
    }
}
