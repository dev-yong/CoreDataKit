//
//  PresistentContainer.swift
//  
//
//  Created by 이광용 on 2021/06/05.
//

import Foundation
import CoreData

public protocol PresistentContainer {
    
    var _container: NSPersistentContainer { get }

}
