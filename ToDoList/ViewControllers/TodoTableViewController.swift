//
//  TodoTableViewController.swift
//  ToDoList
//
//  Created by David D on 12/17/18.
//  Copyright © 2018 David D. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    // managed our managed objects (todos) and update tableview
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // request
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true) // sort by date asc
        request.sortDescriptors = [sortDescriptors]
        
        // initialize
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.manageContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        resultsController.delegate = self
        
        // fetch
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        // Configure the cell...
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // TODO: delete todo
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do {
                try? self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("Error deleting todo: \(error)")
                completion(false)
            }
        }
        
        //action.image = UIImage(named: "trash.png")
        action.title = "Delete"
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            // TODO: check todo
            completion(true)
        }
        
        //action.image = UIImage(named: "check.png")
        action.title = "Complete"
        action.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let _ = sender as? UIBarButtonItem, let viewController = segue.destination as? AddTodoViewController {
            // use the resultsController delegate managed context which has a copy of our data context
            viewController.managedContext = resultsController.managedObjectContext
        }
    }
}

extension TodoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            case .delete:
                if let indexPath = newIndexPath {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            default:
                break
            }
    }
}
