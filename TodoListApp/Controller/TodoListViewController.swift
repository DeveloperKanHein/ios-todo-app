//
//  ViewController.swift
//  TodoListApp
//
//  Created by Kan Hein on 25/04/2023.
//

import UIKit

class TodoListViewController: UITableViewController {
    var todoList: [TodoModel]  = []
//    let userDefault = UserDefaults.standard
    let todoListFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("todo.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To Know Device ID and Application ID
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let pathForDocumentDir = documentsPath[0]
//        print("pathForDocumentDir: \(pathForDocumentDir)")
//        if let todos = userDefault.array(forKey: "todo_list") as? [TodoModel] {
//            todoList = todos
//        }
        
        read()
    }
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todo = todoList[indexPath.row]
        cell.textLabel?.text = todo.name
        cell.accessoryType = todo.check ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        todoList[indexPath.row].check = !todoList[indexPath.row].check
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default){ (action) in
            let todo = TodoModel()
            todo.name = textField.text!
            self.todoList.append(todo)
//            self.userDefault.set(self.todoList, forKey: "todo_list")
            self.save()
            self.tableView.reloadData()
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Enter new todo"
            textField = alertTextField
        }
        alert.addAction(action )
        present(alert, animated: true, completion: nil)
    }
    
    func save(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(todoList)
            try data.write(to: todoListFilePath!)
        }catch{
            print("Error in data saving!!!")
        }
    }
    
    func read(){
        if let data = try? Data(contentsOf: todoListFilePath!){
            let decoder = PropertyListDecoder()
            do{
                todoList = try decoder.decode([TodoModel].self, from: data)
            }catch{
                print("Data reading error!!!")
            }
        }
    }
}

