//
//  CoreDataStack.swift
//  
//
//  Created by 이광용 on 2020/12/15.
//

import CoreData

class CoreDataStack {
    
    private let container: NSPersistentContainer
    private var storeRemoteChangeToken: NSObjectProtocol?
    
    init(
        name: String
    ) {
        
        self.container = NSPersistentContainer(name: name)
        self.setUpPersistentContainer()
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        
        self.container.newBackgroundContext()
    }
    
    private func setUpPersistentContainer() {
        
        self.container.persistentStoreDescriptions.first?
            .setOption(
                true as NSNumber,
                forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
            )
        self.container.loadPersistentStores { (storeDescription, error) in
            
            guard error == nil else {
                
                fatalError("Unresolved error \(error!)")
            }
        }
        self.container.viewContext.automaticallyMergesChangesFromParent = false
        self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        self.storeRemoteChangeToken = NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: nil,
            queue: nil) { (_) in
            
            print("\(#function): Got a persistent store remote change notification!")
        }
    }

}
