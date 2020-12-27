//
//  MOC+Ext.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import CoreData
import Combine

extension NSManagedObjectContext {
    
    func update<T: MOConvertible>(
        entities: [T]
    ) -> AnyPublisher<[T.ManagedObjectType], Error> {
        let insertRequest = BatchRequest.insert(entities: entities)
        insertRequest.resultType = .objectIDs
        let result: Result<[T.ManagedObjectType], Error> = {
            do {
                guard let insertResult = try self.execute(insertRequest) as? NSBatchInsertResult,
                      let objectIDArray = insertResult.result as? [NSManagedObjectID] else {
                    return .failure(BatchReqeustError.insertFailed)
                }
                let managedObjects = objectIDArray
                    .compactMap { self.object(with: $0) as? T.ManagedObjectType }
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: [NSInsertedObjectsKey: objectIDArray],
                    into: [self]
                )
                return .success(managedObjects)
            } catch {
                return .failure(error)
            }
        }()
        return result.publisher.eraseToAnyPublisher()
    }
    
    func entities<T: MOConvertible>(
        fetchRequest: NSFetchRequest<T.ManagedObjectType>,
        sectionNameKeyPath: String? = nil,
        cacheName: String? = nil
    ) -> AnyPublisher<[T], Error>
    where T.ManagedObjectType.DomainType == T {
        return self.publisher(
            fetchRequest: fetchRequest,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
        .map { $0.compactMap { try? $0.asDomain() } }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
    
    func delete<T: MOConvertible>(
        type entityType: T.Type = T.self,
        predicate: NSPredicate? = nil
    ) -> AnyPublisher<Void, Error> {
        let deleteRequest = BatchRequest.delete(
            type: entityType,
            predicate: predicate
        )
        deleteRequest.resultType = .resultTypeObjectIDs
        let result: Result<Void, Error> = {
            do {
                guard let result = try self.execute(deleteRequest) as? NSBatchDeleteResult,
                      let objectIDArray = result.result as? [NSManagedObjectID] else {
                    return .failure(BatchReqeustError.deleteFailed)
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
        }()
        return result.publisher.eraseToAnyPublisher()
    }
    
}
