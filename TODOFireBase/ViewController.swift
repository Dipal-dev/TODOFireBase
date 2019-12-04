//
//  ViewController.swift
//  TODOFireBase
//
//  Created by Dipal Patel on 2019-11-27.
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    @IBOutlet weak var tableView: UITableView!
    var todoList = [Todo]()
    var switchView:UISwitch?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Dipal 1");
        
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        self.todoList.removeAll()
        let ref = Database.database().reference()
        ref.child("todoList").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    let todo = Todo()
                    if let value = snapshot.value as? [String: Any] {
                        
                        todo.uniqueId = snapshot.key
                        todo.name = value["name"] as? String ?? ""
                        todo.message = value["message"] as? String ?? ""
                        todo.reminderDate = value["date"] as? String ?? ""
                        todo.completed = value["status"] as? String ?? ""
                      
                        self.todoList.append(todo)
                    }
                }
            }
            self.tableView.reloadData()
            
        }) { (error) in
            print("Dipal"+error.localizedDescription)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")
        cell!.textLabel?.text = todoList[indexPath.row].name
        //switch make to the table view
        var switchStatus:Bool
        print(indexPath.row)
        if(todoList[indexPath.row].completed == "true"){
            print("Dipal Switch true")
            switchStatus = true
        } else {
            switchStatus = false
        }
        switchView = UISwitch(frame: .zero)
        switchView!.setOn(switchStatus, animated: true)
        switchView!.tag = indexPath.row // for detect which row switch Changed
        switchView!.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell!.accessoryView = switchView
        return cell!
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        print(switchView!.tag)
        if sender.isOn {
            todoList[switchView!.tag].completed = "true"
        } else {
            todoList[switchView!.tag].completed = "false"
        }
      
       
        let key = todoList[switchView!.tag].uniqueId
        print("Dipal key to update"+key!)
        let ref = Database.database().reference()
        
        let dictionaryTodo = [ "name"    : todoList[switchView!.tag].name ,
                               "message" : todoList[switchView!.tag].message,
                               "date"    : todoList[switchView!.tag].reminderDate,
                               "status"  : todoList[switchView!.tag].completed!]
        
        let childUpdates = ["/todoList/\(key!)": dictionaryTodo]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
     
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let todoupdate = self.storyboard!.instantiateViewController(withIdentifier: "ToDoUpdate") as! UpdateViewController
        todoupdate.todo = todoList[indexPath.row]

        self.navigationController?.pushViewController(todoupdate, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
   
            let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this cell", preferredStyle: .alert)
            
            // yes action
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                // put code to remove tableView cell here
                let postID = self.todoList[indexPath.row].uniqueId
                print(postID!)
                Database.database().reference().child("todoList").child(postID!).removeValue()
                self.todoList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            alert.addAction(yesAction)
            // cancel action
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }

}

