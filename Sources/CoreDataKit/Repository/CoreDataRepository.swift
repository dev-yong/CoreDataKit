//
//  CDRepository.swift
//  
//
//  Created by 이광용 on 2020/12/03.
//

import CoreData
import Combine

open class CoreDataRepository<T: CoreDataConvertible>: RepositoryProtocol {
   
    let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
    
    public func save(
        entity: T
    ) -> AnyPublisher<Void, Error> {
        return entity.sync(in: self.context)
            .mapToVoid()
            .flatMap(self.context.ext.save)
            .eraseToAnyPublisher()
    }
    
    public func query(
        with predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) -> AnyPublisher<Void, Error> {
        fatalError()
    }
    
    public func delete(entity: T) -> AnyPublisher<Void, Error> {
        return entity.sync(in: self.context)
            .map { $0 as! NSManagedObject }
            .flatMap(self.context.ext.delete)
            .eraseToAnyPublisher()
    }
    
}

