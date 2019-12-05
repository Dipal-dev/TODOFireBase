//
//  File Name: ToDoViewController.swift
//  App name: TODOFireBase
//  Student ID: 301090880
//  Author's name: Dipal Patel on 2019-11-27.
//  File Description: Main ViewController which list all todo's
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import UIKit
import Firebase

class TodoViewController: UIViewController {
    
    //attributes
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    @IBOutlet weak var todoMessage: UITextView!
    @IBOutlet weak var errorStatus: UITextField!
    var todo:Todo?
    var validation = Validation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //cancel button
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //save data to realtime firebase database after validating the data
    @IBAction func saveData(_ sender: Any) {
        if todo == nil {
            todo = Todo()
        }
        //Validate text fields
        
        let isTitleEmpty = self.validation.validateStringEmpty(name: todoTitle.text!)
        let isMessageEmpty = self.validation.validateStringEmpty(name: todoMessage.text!)
        let isTitleValid = self.validation.validateTitle(name: todoTitle.text!)
        let isMessageValid = self.validation.validateMessage(name: todoTitle.text!)
        
        if(isTitleEmpty == true && isMessageEmpty == true){
            self.errorStatus.text = "Title and Message can't be empty"
            return
        }else if (isTitleEmpty == true) {
            self.errorStatus.text = "Title can't be empty"
            return
        }else if(isMessageEmpty == true){
            self.errorStatus.text = "Message can't be empty"
            return
        } else if(isTitleValid == false){
            self.errorStatus.text = "Title can only be 25 character long."
            return
        }else if(isMessageValid == false){
            self.errorStatus.text = "Message can only be 200 character long."
            return
        }else {
            self.errorStatus.text = ""
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
                               "date"    : todo!.reminderDate!,
                               "status"  : todo!.completed!]

        
        let childUpdates = ["/todoList/\(key!)": dictionaryTodo]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}
