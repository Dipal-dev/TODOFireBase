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
        print("Dipal 2");
        self.todoList.removeAll()
        let ref = Database.database().reference()
        ref.child("todoList").observeSingleEvent(of: .value, with: { (snapshot) in
            print("Dipal 3");
            for child in snapshot.children {
                print("Dipal 4");
                if let snapshot = child as? DataSnapshot {
                    print("Dipal 5");
                    let todo = Todo()
                    print(snapshot)
                    if let value = snapshot.value as? [String: Any] {
                        todo.uniqueId = snapshot.key
                        print("uniqueId"+todo.uniqueId!)
                        print("Dipal 6");
                        todo.name = value["name"] as? String ?? ""
                        todo.message = value["message"] as? String ?? ""
                        todo.reminderDate = value["date"] as? String ?? ""
                        print(todo.name as Any)
                        print(todo.message as Any)
                        print(todo.reminderDate as Any)
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
        //cell.myImage?.image = UIImage(named:"unchecked")
        return cell!
    }
   

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let todoVC = self.storyboard!.instantiateViewController(withIdentifier: "ToDoVC") as! TodoViewController
        todoVC.todo = todoList[indexPath.row]
        //let todo = todoList[indexPath.row]
        //performSegue(withIdentifier: "updateToDo", sender: todo)
        self.navigationController?.pushViewController(todoVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
   
            print("Dipal delete 3")
            let postID = todoList[indexPath.row].uniqueId
            print("Dipal delete 4")
            print(postID!)
            Database.database().reference().child("todoList").child(postID!).removeValue()
            print("Dipal delete 5")
            print("Dipal delete 2")
            self.todoList.remove(at: indexPath.row)
            print("Dipal delete 1")
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
        }
    }

}

