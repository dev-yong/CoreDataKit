//
//  Array+Ext.swift
//  
//
//  Created by 이광용 on 2020/12/27.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
}
