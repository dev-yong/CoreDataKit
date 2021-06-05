//
//  Publishers+FetchedResults.swift
//  
//
//  Created by 이광용 on 2020/12/27.
//

import CoreData
import Combine

extension NSManagedObjectContext {
    
    public func publisher<T>(
        fetchRequest: NSFetchRequest<T>,
        sectionNameKeyPath: String? = nil,
        cacheName: String? = nil
    ) -> AnyPublisher<[T], Error>
    where T: NSFetchRequestResult {
        return Publishers.FetchedResults<T>(
            request: fetchRequest,
            moc: self,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
        .eraseToAnyPublisher()
    }
    
}

extension Publishers {
    
    struct FetchedResults<T>: Publisher
    where T: NSFetchRequestResult {
        
        // MARK: FetchedResultsController
        private let fetchedResultsController: NSFetchedResultsController<T>
        
        init(
            request: NSFetchRequest<T>,
            moc: NSManagedObjectContext,
            sectionNameKeyPath: String? = nil,
            cacheName: String? = nil
        ) {
            self.fetchedResultsController = NSFetchedResultsController<T>(
                fetchRequest: request,
                managedObjectContext: moc,
                sectionNameKeyPath: sectionNameKeyPath,
                cacheName: cacheName
            )
        }
        
        // MARK: Publisher
        typealias Output = [T]
        typealias Failure = Error
        
        func receive<S>(
            subscriber: S
        ) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            
            let subscription = FRCSubscription(
                subscriber: subscriber,
                fetchedResultsController: self.fetchedResultsController
            )
            subscriber.receive(
                subscription: subscription
            )
        }
        
        private final class FRCSubscription<S: Subscriber>
        : NSObject, Subscription, NSFetchedResultsControllerDelegate
        where S.Input == FetchedResults.Output, S.Failure == Error {
            
            // MARK: Subscription
            private var subscriber: S?
            private var fetchedResultsController: NSFetchedResultsController<T>?
            
            init(
                subscriber: S,
                fetchedResultsController: NSFetchedResultsController<T>
            ) {
                self.subscriber = subscriber
                self.fetchedResultsController = fetchedResultsController
                
                super.init()
            
                self.fetchedResultsController?.delegate = self
                
                self.fetchedResultsController?
                    .managedObjectContext
                    .perform { [weak self] in
                        guard let self = self else { return }
                        do {
                            try self.fetchedResultsController?.performFetch()
                            self.emitAsNeeded()
                        } catch {
                            self.subscriber?.receive(completion: .failure(error))
                        }
                    }
            }
            
            private var requestedDemand: Subscribers.Demand = .none
            
            func request(
                _ demand: Subscribers.Demand
            ) {
                if demand != .none {
                    self.requestedDemand += demand
                }
                self.emitAsNeeded()
            }
            
            func cancel() {
                
                self.subscriber = nil
                self.fetchedResultsController = nil
            }

            private func emitAsNeeded() {
                guard self.requestedDemand > .none else { return }
                let objects = self.fetchedResultsController?.fetchedObjects ?? []
                if let demand = self.subscriber?.receive(objects) {
                    self.requestedDemand += demand
                }
                self.requestedDemand -= 1
            }
            
            // MARK: NSFetchedResultsControllerDelegate
            func controllerDidChangeContent(
                _ controller: NSFetchedResultsController<NSFetchRequestResult>
            ) {
                self.emitAsNeeded()
            }
            
        }
        
    }
    
}

