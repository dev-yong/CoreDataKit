//
//  MOC+Ext.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import CoreData

extension NSManagedObject {
    
    @objc func update(property: Property) throws {
        
    }
    
}

extension NSManagedObjectContext {
    
    func insert(
        entityName: String,
        with propertyList: PropertyList
    ) -> Result<Void, Error> {
        let insertRequest = BatchRequest.insert(entityName: entityName, with: propertyList)
        insertRequest.resultType = .statusOnly
        do {
            guard let insertResult = try self.execute(insertRequest) as? NSBatchInsertResult,
                  let success = insertResult.result as? Bool,
                  success else {
                return .failure(BatchRequest.Error.insertionIsFailed)
            }
            return .success(Void())
        } catch {
            return .failure(error)
        }
    }
    
    func update(
        entityName: String,
        with property: Property,
        predicate: NSPredicate? = nil
    ) -> Result<Void, Error> {
        let updateRequest = BatchRequest.update(
            entityName: entityName,
            with: property,
            predicate: predicate
        )
        updateRequest.resultType = .updatedObjectIDsResultType
        do {
            guard let result = try self.execute(updateRequest) as? NSBatchUpdateResult,
                  let objectIDArray = result.result as? [NSManagedObjectID] else {
                
                return .failure(BatchRequest.Error.updateIsFailed)
            }
            return .success(
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: [NSUpdatedObjectsKey: objectIDArray],
                    into: [self]
                )
            )
        } catch {
            return .failure(error)
        }
    }
    
    func delete(
        entityName: String,
        predicate: NSPredicate? = nil
    ) -> Result<Void, Error> {
        let deleteRequest = BatchRequest.delete(
            entityName: entityName,
            predicate: predicate
        )
        do {
            guard let result = try self.execute(deleteRequest) as? NSBatchDeleteResult,
                  let objectIDArray = result.result as? [NSManagedObjectID] else {
                return .failure(BatchRequest.Error.deletionIsFailed)
            }
            return .success(
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: [NSDeletedObjectsKey: objectIDArray],
                    into: [self]
                )
            )
        } catch {
            return .failure(error)
        }
    }
    
}
