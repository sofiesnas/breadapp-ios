//
//  CoreDataCalls.swift
//  BreadApp
//
//  Created by Syafa Sofiena on 23/5/2023.
//

import UIKit
import CoreData

class APICalls {
    
    /**
     Creates entry in Core Data for Meal Log
     - Parameter name: Name of meal
     - Parameter feeling: How user feels
     - Parameter reason: Why user eats
     - Parameter taste: How user thinks of the meal
     - Parameter photo: Photo of meal
    */
    public func addMealLog(name: String, feeling: String, reason: String, taste: String, photo: UIImage? = nil, date: Date = Date()) {
      
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        //Create Meal Log Item
        var entity = NSEntityDescription.entity(forEntityName: "MealLog", in: managedContext)!
        let object: NSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
          
        object.setValue(name, forKeyPath: "name")
        object.setValue(feeling, forKeyPath: "feeling")
        object.setValue(reason, forKeyPath: "reason")
        object.setValue(taste, forKeyPath: "taste")
        object.setValue(date, forKeyPath: "date")

        if let image = photo {
            if let data = image.pngData() as NSData? {
                object.setValue(data, forKey: "photo")
            }
        }
        do {
            try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Update entry in Core Data for Meal Log
    public func updateMealLog(name: String, feeling: String, reason: String, taste: String, photo: UIImage, object: NSManagedObject) {

        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        object.setValue(name, forKeyPath: "name")
        object.setValue(feeling, forKeyPath: "feeling")
        object.setValue(reason, forKeyPath: "reason")
        object.setValue(taste, forKeyPath: "taste")
        
        if let data = photo.pngData() as NSData? {
            object.setValue(data, forKey: "photo")
        }
        do {
            try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Retrieves all meal logs
    public func getMealLogs(completion: @escaping (_ menuItems: [NSManagedObject]) -> Void) {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion([])
            return
        }
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MealLog")
        
        do {
            let items: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            completion(items)
        } catch let error as NSError {
            print("Could not entries. \(error), \(error.userInfo)")
            completion([])
        }
    }
    
    // Deletes entry in Core Data for Menu Log
    public func deleteItem(objToDelete: NSManagedObject) -> Bool {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(objToDelete)
        
        do {
            try managedContext.save()
                return true
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
}
