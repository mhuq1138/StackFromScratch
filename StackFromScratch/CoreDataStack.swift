//
//  CoreDataStack.swift
//  StackFromScratch
//
//  Created by Mazharul Huq on 2/8/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import CoreData

class CoreDataStack{
    let modelName:String
    
    init(modelName:String){
        self.modelName = modelName
    }
    
    //Create the data model instance
    lazy var managedObjectModel:NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName,
                                             withExtension: "momd") else{
            fatalError("Unable to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else{
            fatalError("Unable to load data model")
        }
        return mom
    }()
    
   
    
    //Creating URL for store file
    private lazy var storeURL:URL = {
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        let docDirURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = docDirURL.appendingPathComponent(storeName)
        return url
    }()
    
    //Create the persistent store coordinator
    lazy var persistentStoreCoordinator:NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        }catch{
            fatalError("Unable to load persistent store")
        }
        return psc
    }()
    
    //Create the managed object context
    lazy var managedObjectContext:NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
        
    }()
    
    func saveContext()->Bool{
        guard self.managedObjectContext.hasChanges else{
            return false
        }
        do {
             try self.managedObjectContext.save()
            return true
        }catch let error as NSError{
            print("Unresolved error \(error), \(error.userInfo)")
            return false

        }
    }

}
