//
//  ListViewController.swift
//  TraditionalCoreDataStack
//
//  Created by Mazharul Huq on 1/13/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var coreDataStack = CoreDataStack(modelName: "PersonList")
    var persons:[NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Person List"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            persons = try self.coreDataStack.managedObjectContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError{
            print("Could not fetch. \(error),\(error.userInfo)")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let person = persons[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "firstName") as? String
        cell.detailTextLabel?.text = person.value(forKey: "lastName") as? String
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = persons[indexPath.row]
            self.coreDataStack.managedObjectContext.delete(person)
            //Save context
            
            if self.coreDataStack.saveContext(){
                persons.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
           
        }
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditViewController
        vc.coreDataStack = self.coreDataStack
        if segue.identifier == "editSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                vc.person = self.persons[indexPath.row]
            }
        }
    }
    

}
