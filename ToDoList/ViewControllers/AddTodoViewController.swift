//
//  AddTodoViewController.swift
//  ToDoList
//
//  Created by David D on 12/17/18.
//  Copyright © 2018 David D. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    // MARK: Outlets

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
            name: .UIKeyboardWillShow,
            object: nil
        )
    }
    
    // MARK: Actions
    @objc func keyboardWillShow(with notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[""] as? NSValue else { return } // NSValue - objc wrapper
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
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
