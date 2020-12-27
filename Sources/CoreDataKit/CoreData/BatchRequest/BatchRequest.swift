//
//  BatchRequest.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import CoreData

enum BatchRequest {
    
    static func insert<T: MOConvertible>(
        entities: [T]
    ) -> NSBatchInsertRequest {
        var index = 0
        let totalCount = entities.count
        let entityName = String(describing: T.ManagedObjectType.self)
        return NSBatchInsertRequest(
            entityName: entityName,
            managedObjectHandler: { (managedObject) -> Bool in
                guard index < totalCount else { return true }
                if let object = managedObject as? T.ManagedObjectType,
                   let entity = entities[safe: index] {
                    entity.sync(managedObject: object)
                }
                index += 1
                return false
            }
        )
    }
    
    static func delete<T: MOConvertible>(
        type entityType: T.Type = T.self,
        predicate: NSPredicate? = nil
    ) -> NSBatchDeleteRequest {
        let entityName = String(describing: T.ManagedObjectType.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
    
}

enum BatchReqeustError: Error {
    
    case insertFailed
    case deleteFailed
    
}
