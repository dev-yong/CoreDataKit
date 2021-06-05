//
//  DomainConvertible.swift
//  
//
//  Created by 이광용 on 2020/12/04.
//

import CoreData

public protocol DomainConvertible: NSFetchRequestResult {
    
    associatedtype DomainType
    
    func asDomain() throws -> DomainType
    static func fetchRequest() -> NSFetchRequest<Self>
}

public enum DomainConvertError: Error {
    
    case convertingIsFailed
    
}
