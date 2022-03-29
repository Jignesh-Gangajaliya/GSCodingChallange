//
//  PersistentStorage.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 29/03/22.
//

import CoreData

final class PersistentStorage {

    private init() {}
    
    static let shared = PersistentStorage()

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "GSCodingChallange")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Data saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
