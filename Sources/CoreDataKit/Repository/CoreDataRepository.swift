//
//  CDRepository.swift
//  
//
//  Created by 이광용 on 2020/12/03.
//

import CoreData
import Combine

open class CoreDataRepository<T: MOConvertible>: RepositoryProtocol
where T.ManagedObjectType.DomainType == T {
    
    public let persistentContainer: PresistentContainer
    public let context: NSManagedObjectContext
    
    public init(
        name: String
    ) {
        let coreDataStack = CoreDataStack(name: name)
        self.persistentContainer = coreDataStack
        self.context = coreDataStack.backgroundContext()
    }
    
    public init(
        persistentContainer: PresistentContainer,
        context: NSManagedObjectContext
    ) {
        self.persistentContainer = persistentContainer
        self.context = context
    }
    
    public func update(
        entities: [T]
    ) -> AnyPublisher<Void, Error> {
        return self.context.update(
            entities: entities
        ).mapToVoid()
    }
    
    public func query(
        with predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> AnyPublisher<[T], Error> {
        let request: NSFetchRequest<T.ManagedObjectType> = T.ManagedObjectType.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return self.context.entities(fetchRequest: request)
    }

    public func delete(
        predicate: NSPredicate? = nil
    ) -> AnyPublisher<Void, Error> {
        self.context.delete(
            type: T.self,
            predicate: predicate
        )
    }
    
}
