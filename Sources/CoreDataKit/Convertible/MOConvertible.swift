//
//  MOConvertible.swift
//  
//
//  Created by 이광용 on 2020/12/27.
//

import CoreData

protocol MOConvertible {
    
    associatedtype ManagedObjectType: NSManagedObject, DomainConvertible
    
    func sync(managedObject: ManagedObjectType)
    
}
