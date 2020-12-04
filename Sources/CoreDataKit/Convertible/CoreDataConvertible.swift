//
//  CoreDataConvertible.swift
//  
//
//  Created by 이광용 on 2020/12/04.
//

import Foundation
import CoreData
import Combine

public protocol CoreDataConvertible {
    
    associatedtype T
    
    func update(entity: T)
    
}

extension CoreDataConvertible {
    
    func sync(
        in context: NSManagedObjectContext
    ) -> AnyPublisher<T, Error> {
//        return context.rx.sync(entity: self, update: update)
        fatalError()
    }
    
}
    
