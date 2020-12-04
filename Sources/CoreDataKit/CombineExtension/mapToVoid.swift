//
//  mapToVoid.swift
//  
//
//  Created by 이광용 on 2020/12/04.
//

import Combine

extension AnyPublisher {
    
    func mapToVoid() -> AnyPublisher<Void, Failure> {
        
        return self.map { _ in Void() }
            .eraseToAnyPublisher()
    }
}
