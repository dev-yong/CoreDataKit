//
//  RepositoryProtocol.swift
//  
//
//  Created by 이광용 on 2020/12/02.
//

import Foundation
import Combine

public protocol RepositoryProtocol {
    
    associatedtype T
    
    /// Create or Update
    func update(
        entities: [T]
    ) -> AnyPublisher<Void, Error>
    
    /// Read
    func query(
        with predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) -> AnyPublisher<[T], Error>
    
    /// Delete
    func delete(
        predicate: NSPredicate?
    ) -> AnyPublisher<Void, Error>
    
}
