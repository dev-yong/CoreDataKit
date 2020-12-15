//
//  FetchedResults+Publihser.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import Combine
import CoreData

extension NSManagedObjectContext {
    
    func publisher<T, F>(
        fetchRequest: NSFetchRequest<T>,
        sectionNameKeyPath: String,
        cacheName: String?
    ) -> Publishers.FetchedResults<T, F>
    where T: NSFetchRequestResult, F: Error {
        return Publishers.FetchedResults(
            request: fetchRequest,
            moc: self,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
    }
    
}

extension Publishers {
    
    struct FetchedResults<T, F>: Publisher
    where T: NSFetchRequestResult, F: Error {
        
        // MARK: FetchedResultsController
        private let fetchedResultsController: NSFetchedResultsController<T>
        
        init(
            request: NSFetchRequest<T>,
            moc: NSManagedObjectContext,
            sectionNameKeyPath: String,
            cacheName: String?
        ) {
            self.fetchedResultsController = NSFetchedResultsController<T>(
                fetchRequest: request,
                managedObjectContext: moc,
                sectionNameKeyPath: sectionNameKeyPath,
                cacheName: cacheName
            )
        }
        
        // MARK: Publisher
        typealias Output = CollectionDifference<T>
        typealias Failure = F
        
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
        where S.Input == FetchedResults.Output {
            
            // MARK: Subscription
            private let subscriber: S
            private weak var fetchedResultsController: NSFetchedResultsController<T>?
            
            init(
                subscriber: S,
                fetchedResultsController: NSFetchedResultsController<T>
            ) {
                self.subscriber = subscriber
                self.fetchedResultsController = fetchedResultsController
                
                super.init()
                
                self.fetchedResultsController?.delegate = self
            }
            
            func request(
                _ demand: Subscribers.Demand
            ) {
                
            }
            
            func cancel() {
                
            }
            
            // MARK: NSFetchedResultsControllerDelegate
            func controller(
                _ controller: NSFetchedResultsController<NSFetchRequestResult>,
                didChangeContentWith diff: CollectionDifference<NSManagedObjectID>
            ) {
                
            }
            
            func controllerDidChangeContent(
                _ controller: NSFetchedResultsController<NSFetchRequestResult>
            ) {
                
            }
        }
        
    }
    
}
