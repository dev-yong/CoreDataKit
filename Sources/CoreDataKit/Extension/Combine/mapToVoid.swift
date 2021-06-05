//
//  mapToVoid.swift
//  
//
//  Created by 이광용 on 2020/12/27.
//

import Combine

extension Publisher {
    
    public func mapToVoid() -> AnyPublisher<Void, Failure> {
        self.map { _ in Void() }
            .eraseToAnyPublisher()
    }
    
}
