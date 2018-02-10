//
//  EditViewController.swift
//  TraditionalCoreDataStack
//
//  Created by Mazharul Huq on 1/13/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    
    var coreDataStack:CoreDataStack!
    var person:NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameField.text = self.person?.value(forKey: "firstName") as? String
        self.lastNameField.text = self.person?.value(forKey: "lastName") as? String
    }

    @IBAction func saveTapped(_ sender: Any) {
        var personToSave: NSManagedObject
        if let person = self.person{
            personToSave = person
            
        }
        else{
            // 1
            // A class method of NSEnityDescription is used to create an instance of Item
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: self.coreDataStack.managedObjectContext)
            //2
            //An instance of Item is created using an initializer that takes the entity
            //created above and a managed object context as arguments
            personToSave = NSManagedObject(entity: entity!, insertInto: self.coreDataStack.managedObjectContext)
            
        }
        
        let firstName = self.firstNameField.text
        let lastName = self.lastNameField.text
        
        //3
        //Set vlaues of the attribute using KVC
        personToSave.setValue(firstName, forKey: "firstName")
        personToSave.setValue(lastName, forKey: "lastName")
        
        //4
        //Save the changes to the context
        if self.coreDataStack.saveContext(){
            self.navigationController?.popViewController(animated: true)
        }
    
    }
}
