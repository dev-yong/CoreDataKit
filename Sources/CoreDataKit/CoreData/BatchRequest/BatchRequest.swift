//
//  BatchRequest.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import CoreData

typealias Property = [String: Any]
typealias PropertyList = [Property]

enum BatchRequest {
    
    enum Error: Swift.Error {
        
        case insertionIsFailed
        case updateIsFailed
        case deletionIsFailed
        
    }
    
    static func insert(
        entityName: String,
        with propertyList: PropertyList
    ) -> NSBatchInsertRequest {
        var index = 0
        let totalCount = propertyList.count
        return NSBatchInsertRequest(
            entityName: entityName,
            dictionaryHandler: { (dictionary) -> Bool in
                guard index < totalCount else { return true }
                index += 1
                return false
            }
        )
    }
    
    static func update(
        entityName: String,
        with property: Property,
        predicate: NSPredicate? = nil
    ) -> NSBatchUpdateRequest {
        let request = NSBatchUpdateRequest(entityName: entityName)
        request.predicate = predicate
        request.propertiesToUpdate = property
        return request
    }
    
    static func delete(
        entityName: String,
        predicate: NSPredicate? = nil
    ) -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
    
}
