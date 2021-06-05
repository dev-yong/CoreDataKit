//
//  CoreDataStack.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import CoreData
import Combine

open class CoreDataStack: PresistentContainer {
    
    public let _container: NSPersistentContainer
    private var storeRemoteChangeToken: NSObjectProtocol?
    
    public init(
        name: String
    ) {
        self._container = NSPersistentContainer(name: name)
        self.setUpPersistentContainer()
    }
    
    open func backgroundContext() -> NSManagedObjectContext {
        let context = self._container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    private func setUpPersistentContainer() {
        self._container.persistentStoreDescriptions.first?
            .setOption(
                true as NSNumber,
                forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
            )
        self._container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        self._container.viewContext.automaticallyMergesChangesFromParent = false
        self._container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self._container.viewContext.shouldDeleteInaccessibleFaults = true
        
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .sink { _ in
                
                print("\(#function): Got a persistent store remote change notification!")
            }.store(in: &self.cancellableBag)
    }
    
    private var cancellableBag = Set<AnyCancellable>()
    
}
