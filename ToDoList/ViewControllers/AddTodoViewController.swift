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
    
    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
        textView.resignFirstResponder() // hide keyboard
    }
    
    @IBAction func done(_ sender: Any) {
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        let todo = Todo(context: managedContext)
        todo.title = title
        todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        todo.date = Date()
        
        do {
            try? managedContext.save()
            dismiss(animated: true) // only dismiss on successful save
            textView.resignFirstResponder() // hide keyboard
        } catch {
            print("Error saving todo: \(error)")
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
