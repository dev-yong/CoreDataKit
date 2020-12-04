//
//  DomainConvertible.swift
//  
//
//  Created by 이광용 on 2020/12/04.
//

import Foundation

public protocol DomainConvertible {
    
    associatedtype T
    
    func asDomain() -> T
    
}
