//
//  Result+Ext.swift
//  
//
//  Created by 이광용 on 2020/12/27.
//

import Foundation

import Foundation

extension Result {
    
    public func mapToVoid() -> Result<Void, Failure> {
        return self.map { _ in Void() }
    }
    
}
