//
//  CoreDataController.swift
//  student-id
//
//  Created by John Clarke on 9/17/16.
//  Copyright © 2016 John Clarke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataController: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    
    override  init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Cache", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("Up_and_Running_With_Core_Data.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    func deleteFromCoreData(_ entity: String){
        let object = self.managedObjectContext
        let objectFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        do {
            let fetchedObjects = try object.fetch(objectFetch)
            if (fetchedObjects.count != 0) {
                for i in 0...(fetchedObjects.count-1) {
                    let fetchedObject = fetchedObjects[i] as! NSManagedObject
                    object.delete(fetchedObject)
                }
            }
        } catch {
            fatalError("Failed to fetch object: \(error)")
        }
        do {
            try object.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    func clearCoreData(_ entities: [String]) {
        for i in 0...(entities.count-1) {
            let entity: String = entities[i]
            deleteFromCoreData(entity)
        }
    }
    
    func saveToCoreData(_ entityName : String, data: [String:String]) {
        let managedContext = self.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: entityName, in:managedContext)
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        for i in 0...(data.count-1) {
            let label = Array(data.keys)[i]
            object.setValue(data[label], forKey: label)
        }
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // returns a string of message ids to be delete (userid, messageid) sufficient to identify an exact message displayed in a users conversations
    func fetchStudentInfo(_ entity : String, email: String) -> [String:String] {
        let object = self.managedObjectContext
        let objectFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        do {
            let fetchedObjects = try object.fetch(objectFetch)
            if (!fetchedObjects.isEmpty) {
                for i in 0...(fetchedObjects.count-1) {
                    let fetchedObject = fetchedObjects[i] as! NSManagedObject
                    // check if email of logged in user is in coredata; if so don't call API
                    let emailInData: String = fetchedObject.value(forKey: "email") as! String
                    if (emailInData == email) {
                        let firstName = fetchedObject.value(forKey: "firstName") as! String
                        let lastName = fetchedObject.value(forKey: "lastName") as! String
                        let schoolName = fetchedObject.value(forKey: "schoolName") as! String
                        let studentID = fetchedObject.value(forKey: "studentID") as! String
                        let imagePath = fetchedObject.value(forKey: "imagePath") as! String
                        let data = ["firstName" : firstName, "lastName" : lastName, "schoolName" : schoolName, "studentID" : studentID, "imagePath" : imagePath]
                        return data
                    }
                }
                return [:]
            }
        } catch {
            fatalError("Failed to fetch object: \(error)")
        }
    }
    
    static let sharedInstance = CoreDataController()
}
