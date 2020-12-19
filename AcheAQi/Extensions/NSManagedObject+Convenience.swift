//
//  NSManagedObject+Convenience.swift
//  Oconcurs
//
//  Created by Romeu Godoi on 08/09/16.
//  Copyright © 2016 Logics Tecnologia e Serviços. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class func findOrCreateNewObject(withExternalID externalID: NSNumber, context: NSManagedObjectContext, addToContext: Bool) -> NSManagedObject? {
        
        var object: NSManagedObject?
        let request = self.fetchRequest()
        let entityName = request.entityName  //String(describing: type(of: self))
        var createNewObject = !addToContext
        
        if addToContext {
            do {
                
                request.predicate = NSPredicate(format: "externalID = %@", externalID)
                
                let results = try context.fetch(request) as! [NSManagedObject]
                
                if results.count > 0 {
                    
                    object = results.first!
                }
                else {
                    // Create
                    createNewObject = true
                }
            } catch {
                fatalError("Failed to fetch or create NSManagedObject into Core Data: \(error)")
            }
        }
        
        if createNewObject {
            let entityDescription = NSEntityDescription.entity(forEntityName: entityName!, in: context)
            object = self.init(entity: entityDescription!, insertInto: (addToContext ? context : nil))
            
            if addToContext {
                context.insert(object!)
            }
        }
        
        return object
    }
    
    class func findOrCreateNewObject<ResultType: NSManagedObject>(description: NSEntityDescription,
                                                                  info: [String: Any?],
                                                                  context: NSManagedObjectContext,
                                                                  addToContext: Bool) -> ResultType? {
        
        var object: ResultType?
        let request = NSFetchRequest<ResultType>(entityName: description.managedObjectClassName)
        var createNewObject = !addToContext
        
        if addToContext {
            do {
                
                // Find property name and value by NSEntityDescription
                let pkProperty = description.properties.filter { property -> Bool in
                    return property.userInfo?.keys.contains("isPrimaryKey") ?? false
                    }.first
                
                if let pkProp = pkProperty {
                    
                    let pkName = (pkProp.userInfo?["remoteKey"] as? String) ?? pkProp.name
                    let pkValue = info[pkName] as! NSNumber
                    
                    request.predicate = NSPredicate(format: "\(pkProp.name) = %@", pkValue)
                    
                    let results = try context.fetch(request)
                    
                    if results.count > 0 {
                        
                        object = results.first!
                    }
                    else {
                        // Create
                        createNewObject = true
                    }
                }
                else {
                    // Create
                    createNewObject = true
                }
            } catch {
                fatalError("Failed to fetch or create NSManagedObject into Core Data: \(error)")
            }
        }
        
        if createNewObject {
            object = self.init(entity: description, insertInto: (addToContext ? context : nil)) as? ResultType
            
            if addToContext {
                context.insert(object!)
            }
        }
        
        return object
    }
    
    class func findLastUpdatedObject(inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        var object: NSManagedObject?
        
        let request = self.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
        do {
            object = try context.fetch(request).first as! NSManagedObject?
        } catch {
            print("Failed to fetch last updated NSManagedObject into Core Data: \(error)")
        }
        
        return object
    }
    
    class func find(byExternalID externalID: NSNumber, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        var object: NSManagedObject?
        
        let request = self.fetchRequest()
        request.predicate = NSPredicate(format: "externalID = %@", externalID)
        
        do {
            object = try context.fetch(request).first as! NSManagedObject?
        } catch {
            fatalError("Failed to fetch last updated NSManagedObject into Core Data: \(error)")
        }
        
        return object
    }
    
    // Insert object and his relations into MOC
    func insert(to context: NSManagedObjectContext) {
        
        let attributes = self.entity.relationshipsByName
        
        for attr in attributes {
            
            if attr.value.isToMany, let rel = self.value(forKey: attr.key) as? NSSet {
                rel.forEach({ item in
                    if let obj = item as? NSManagedObject {
                        obj.insert(to: context)
                    }
                })
            }
            else if let rel = self.value(forKey: attr.key) as? NSManagedObject {
                rel.insert(to: context)
            }
        }
        
        context.insert(self)
    }
    
    
    
    class func parseJSON<ResultType: NSManagedObject>(info: [String: Any], context: NSManagedObjectContext, addToContext: Bool = true) -> ResultType? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.WSDateFormat
        
        let description = self.entity()
        
        let attributes = description.attributesByName
        
        let obj = self.findOrCreateNewObject(description: description, info: info, context: context, addToContext: addToContext) as? ResultType
        
        var needsToSetData = true
        
        // Check if this obj needs to be updated
        if let updatedAtStr = (info[Constants.updatedAt] as? NSString) as String?,
            let updatedAt = dateFormatter.date(from: updatedAtStr) as NSDate?,
            let objUpdatedAt = (obj as? UpdatableDataModel)?.updatedAt,
            objUpdatedAt.isGreaterOrEqualToDate(dateToCompare: updatedAt) {
            
            needsToSetData = false
        }
        
        if needsToSetData {
            
            for property: NSPropertyDescription in description.properties {
                
                let userInfo = property.userInfo
                
                var value: Any!
                
                if info.keys.contains(property.name) {
                    
                    value = info[property.name]! as Any
                    
                } else if userInfo != nil, userInfo!.keys.contains("remoteKey") {
                    
                    let remoteKey = userInfo!["remoteKey"] as! String
                    
                    if info.keys.contains(remoteKey) {
                        value = info[remoteKey]! as Any
                    }
                }
                
                if value != nil, let attrDesc: NSAttributeDescription = attributes[property.name] {
                    
                    switch attrDesc.attributeType {
                    case .integer16AttributeType:
                        value = value is NSString ? (value as! NSString).integerValue : value
                        value = (value as? NSNumber)?.intValue
                    case .integer32AttributeType:
                        value = value is NSString ? (value as! NSString).integerValue : value
                        value = (value as? NSNumber)?.intValue
                    case .integer64AttributeType:
                        value = value is NSString ? (value as! NSString).integerValue : value
                        value = (value as? NSNumber)?.intValue
                    case .stringAttributeType:
                        value = value as? NSString
                    case .booleanAttributeType:
                        value = (value as? NSNumber)?.boolValue
                    case .decimalAttributeType:
                        value = (value as? NSNumber)?.decimalValue
                    case .doubleAttributeType:
                        value = (value as? NSNumber)?.doubleValue
                    case .floatAttributeType:
                        value = (value as? NSNumber)?.floatValue
                    case .dateAttributeType:
                        if let strDate = (value as? NSString) as String? {
                            value = dateFormatter.date(from: strDate) as NSDate?
                        }
                    case .binaryDataAttributeType:
                        if let strPath = (value as? NSString) as String?, addToContext {
                            value = NSData(contentsOf: URL(wsURLWithPath: strPath))
                        } else {
                            value = nil
                        }
                        
                    default: break
                    }
                    
                    if let val = value, !(val is NSNull) {
                        obj?.setValue(val, forKey: property.name)
                    }
                }
            }
        }
        
        // Relationship Parsing
        for relationMap in description.relationshipsByName {
            
            let propRel = relationMap.value
            
            let relInfo = self.retrieveValueBy(info: info, propertyDesc: propRel)
            
            if let value = relInfo {
                
                let entityDescRel = propRel.destinationEntity
                let tmpObj = NSManagedObject(entity: entityDescRel!, insertInto: nil)
                let classType = type(of: tmpObj)
                
                if !propRel.isToMany {
                    let infoData = value as! [String: Any]
                    let objRel = classType.parseJSON(info: infoData, context: context, addToContext: addToContext)
                    
                    obj?.setValue(objRel, forKey: propRel.name)
                } else {
                    let arrInfoRel = value as! [[String: Any]]
                    
                    if !propRel.inverseRelationship!.isToMany {
                        for infoRel in arrInfoRel {
                            let objRel = classType.parseJSON(info: infoRel, context: context, addToContext: addToContext)
                            
                            objRel?.setValue(obj, forKey: propRel.inverseRelationship!.name)
                        }
                    } else {
                        // Many to Many
                        var items = [NSManagedObject]()
                        
                        for infoRel in arrInfoRel {
                            if let objRel = classType.parseJSON(info: infoRel, context: context, addToContext: addToContext) {
                                
                                items.append(objRel)
                            }
                        }
                        
                        if items.count > 0 {
                            obj?.setValue(NSSet(array: items), forKey: propRel.name)
                        }
                    }
                }
            }
        }
        
        return obj
    }
    
    private class func retrieveValueBy(info: [String: Any?], propertyDesc: NSPropertyDescription) -> Any? {
        
        let userInfo = propertyDesc.userInfo
        
        if info.keys.contains(propertyDesc.name), !(info[propertyDesc.name] is NSNull) {
            return info[propertyDesc.name] ?? nil
        } else if userInfo != nil, userInfo!.keys.contains("remoteKey"), !(userInfo!["remoteKey"] is NSNull) {
            let remoteKey = userInfo!["remoteKey"] as! String
            
            return info[remoteKey] ?? nil
        } else {
            return nil
        }
    }
}

//public func ==(lhs: BasicDataModelProtocol, rhs: BasicDataModelProtocol) -> Bool {
//    return lhs.externalID!.intValue == rhs.externalID!.intValue
//}
