//
//  ExtensionBox.swift
//  
//
//  Created by 이광용 on 2020/12/03.
//

import Foundation

public struct ExtensionBox<Base: AnyObject> {
    
    public let base: Base
    
    public init(_ base: Base) {
        
        self.base = base
    }
    
}

public protocol ExtensionBoxCompatible: AnyObject {
    
    associatedtype Base: AnyObject
    var ext: ExtensionBox<Base> { get }
    
}

public extension ExtensionBoxCompatible {
    
    var ext: ExtensionBox<Self> { ExtensionBox(self) }
    
}

extension NSObject: ExtensionBoxCompatible {}
