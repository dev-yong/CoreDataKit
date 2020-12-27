//
//  CoreDataStack.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import CoreData
import Combine

class CoreDataStack {
    
    private let container: NSPersistentContainer
    private var storeRemoteChangeToken: NSObjectProtocol?
    
    init(
        name: String
    ) {
        self.container = NSPersistentContainer(name: name)
        self.setUpPersistentContainer()
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        let context = self.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    private func setUpPersistentContainer() {
        self.container.persistentStoreDescriptions.first?
            .setOption(
                true as NSNumber,
                forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
            )
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        self.container.viewContext.automaticallyMergesChangesFromParent = false
        self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.container.viewContext.shouldDeleteInaccessibleFaults = true
        
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .sink { _ in
                
                print("\(#function): Got a persistent store remote change notification!")
            }.store(in: &self.cancellableBag)
    }
    
    private var cancellableBag = Set<AnyCancellable>()
    
}
