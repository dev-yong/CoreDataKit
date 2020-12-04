//
//  ExtensionBox+NSManagedObjectContext.swift
//  
//
//  Created by 이광용 on 2020/12/03.
//

import CoreData
import Combine

extension ExtensionBox where Base: NSManagedObjectContext {
    
    func save() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                promise(.success(try self.base.save()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete<E: NSManagedObject>(_ entity: E) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            promise(.success(self.base.delete(entity)))
        }
        .flatMap(self.save)
        .eraseToAnyPublisher()
    }
    
}
