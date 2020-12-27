//
//  CDRepository.swift
//  
//
//  Created by 이광용 on 2020/12/03.
//

import CoreData
import Combine

class CoreDataRepository<T: MOConvertible>: RepositoryProtocol
where T.ManagedObjectType.DomainType == T {
    
    private let coreDataStack: CoreDataStack
    private let moc: NSManagedObjectContext
    
    init(
        name: String
    ) {
        let coreDataStack = CoreDataStack(name: name)
        self.coreDataStack = coreDataStack
        self.moc = coreDataStack.backgroundContext()
    }
    
    func update(
        entities: [T]
    ) -> AnyPublisher<Void, Error> {
        return self.moc.update(
            entities: entities
        ).mapToVoid()
    }
    
    func query(
        with predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> AnyPublisher<[T], Error> {
        let request: NSFetchRequest<T.ManagedObjectType> = T.ManagedObjectType.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return self.moc.entities(fetchRequest: request)
    }

    func delete(
        predicate: NSPredicate? = nil
    ) -> AnyPublisher<Void, Error> {
        self.moc.delete(
            type: T.self,
            predicate: predicate
        )
    }
    
}
