//
//  TableViewController.swift
//  CoreDataApp
//
//  Created by Рустам Т on 2/16/23.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        
        let addNewTask = UIAlertController(title: "new task", message: "add new task", preferredStyle: .alert)
        let saveButton = UIAlertAction(title: "Save", style: .default) { action in
            let tf = addNewTask.textFields?.first
            if let newTask = tf?.text{
                self.saveTitle(with: newTask)
                self.tableView.reloadData()
            }
        }
        addNewTask.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        addNewTask.addAction(saveButton)
        addNewTask.addAction(cancelAction)
        present(addNewTask, animated: true)
    }
    
    
    private func saveTitle(with title: String){
        let context = giveContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do{
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    private func giveContext()-> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = giveContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do{
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = giveContext()
             let object = data[indexPath.row]
                context.delete(object)
        
        do {
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let task = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
    }
    
    
}


