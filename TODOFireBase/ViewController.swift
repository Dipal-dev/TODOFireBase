//
//  File Name: ViewController.swift
//  App name: TODOFireBase
//  Student ID: 301090880
//  Author's name: Dipal Patel on 2019-11-27.
//  File Description: Main ViewController which list all todo's
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //All attributes used in this controller
    @IBOutlet weak var tableView: UITableView!
    var todoList = [Todo]()
    var switchView:UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //load data from firebase realtime database
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

    //method to get row count of tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    //this  function makes cell to be displayed in tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")
        cell!.textLabel?.text = todoList[indexPath.row].name
        //switch make to the table view
        var switchStatus:Bool
        print(indexPath.row)
        if(todoList[indexPath.row].completed == "true"){
            print("Dipal Switch true")
            switchStatus = true
            cell?.backgroundColor = UIColor.lightGray
        } else {
            cell?.backgroundColor = UIColor.white
            switchStatus = false
        }
        var switchView:UISwitch?
        switchView = UISwitch(frame: .zero)
        switchView!.setOn(switchStatus, animated: true)
        switchView!.tag = indexPath.row // for detect which row switch Changed
        switchView!.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell!.accessoryView = switchView
        return cell!
    }
    
    //when switch state is changed this function gets called
    @objc func switchChanged(_ sender : UISwitch!){
        let cell = sender.superview as! UITableViewCell
        let indexpath = tableView.indexPath(for: cell) as! IndexPath
        print(indexpath.row)
        //print(sender.tag)
        if sender.isOn {
            cell.backgroundColor = UIColor.lightGray
            todoList[indexpath.row].completed = "true"
            
        } else {
            cell.backgroundColor = UIColor.white
           todoList[indexpath.row].completed = "false"
        }
      
       
        let key = todoList[indexpath.row].uniqueId
        print("Dipal key to update"+key!)
        let ref = Database.database().reference()
        
        let dictionaryTodo = [ "name"    : todoList[indexpath.row].name ,
                               "message" : todoList[indexpath.row].message,
                               "date"    : todoList[indexpath.row].reminderDate,
                               "status"  : todoList[indexpath.row].completed!]
        
        let childUpdates = ["/todoList/\(key!)": dictionaryTodo]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
     
    }

    //when row is selected this function redirect ti UpdateViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let todoupdate = self.storyboard!.instantiateViewController(withIdentifier: "ToDoUpdate") as! UpdateViewController
        todoupdate.todo = todoList[indexPath.row]

        self.navigationController?.pushViewController(todoupdate, animated: true)
        
    }
    
    //this function provide delete function on swipe left
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

