//
//  AddTodoViewController.swift
//  ToDoList
//
//  Created by David D on 12/17/18.
//  Copyright © 2018 David D. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    var managedContext: NSManagedObjectContext! // ! to force unwrap
    var todo: Todo?
    
    // MARK: - Outlets

    @IBOutlet var textView: UITextView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // listen for keyboard notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        textView.becomeFirstResponder() // open modal with keyboard
        
        // set data on modal if todo exists
        if let todo = todo {
            textView.text = todo.title
            textView.text = todo.title // bug that removes the text because delegate removes the data
            segmentedControl.selectedSegmentIndex = Int(todo.priority)
        }
    }
    
    // MARK: - Actions
    @objc func keyboardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return } // NSValue - objc wrapper
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16 // add 16 point margin
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            // resets the constraints
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismissAndResign() 
    }
    
    @IBAction func done(_ sender: Any) {
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        // check if todo already exists for update
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            print("Error saving todo: \(error)")
        }
    }
}

extension AddTodoViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden {
            textView.text.removeAll()
            textView.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
