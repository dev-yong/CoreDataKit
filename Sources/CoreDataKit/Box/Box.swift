//
//  Box.swift
//  
//
//  Created by 이광용 on 2020/12/03.
//

import Foundation

public struct Box<Base: AnyObject> {
    
    public let base: Base
    
    public init(_ base: Base) {
        
        self.base = base
    }
    
}

public protocol Boxing: AnyObject {
    
    associatedtype Base: AnyObject
    var ext: Box<Base> { get }
    
}

public extension Boxing {
    
    var ext: Box<Self> { Box(self) }
    
}

extension NSObject: Boxing {}
