//
//  DomainConvertible.swift
//  
//
//  Created by 이광용 on 2020/12/04.
//

import CoreData

protocol DomainConvertible: NSFetchRequestResult {
    
    associatedtype DomainType
    
    func asDomain() throws -> DomainType
    static func fetchRequest() -> NSFetchRequest<Self>
}

enum DomainConvertError: Error {
    
    case convertingIsFailed
    
}
