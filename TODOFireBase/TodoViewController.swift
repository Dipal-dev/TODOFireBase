//
//  TodoViewController.swift
//  TODOFireBase
//
//  Created by Dipal Patel on 2019-11-27.
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import UIKit
import Firebase

class TodoViewController: UIViewController {
    
    
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    @IBOutlet weak var todoMessage: UITextView!
    var todo:Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.todo != nil {
            todoTitle.text = self.todo?.name
            todoMessage.text = self.todo?.message
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
            let date = dateFormatter.date(from: self.todo!.reminderDate!)
            todoDate.date = date!
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveData(_ sender: Any) {
        if todo == nil {
            todo = Todo()
        }
        
        // first section
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        todo?.name = self.todoTitle.text
        todo?.message = self.todoMessage.text
        todo?.reminderDate = dateFormatter.string(from: self.todoDate.date)
        
        //second section
        let ref = Database.database().reference()
        let key = ref.child("todoList").childByAutoId().key
        
        let dictionaryTodo = [ "name"    : todo!.name! ,
                               "message" : todo!.message!,
                               "date"    : todo!.reminderDate!]
        
        let childUpdates = ["/todoList/\(key)": dictionaryTodo]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}
