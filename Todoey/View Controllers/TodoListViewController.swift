//
//  TodoListViewController.swift
//  Todoey
//
//  Created by DILIP on 25/6/18.
//  Copyright © 2018 DILIP. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemsArray:[Item] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       var textField = UITextField()
        
       let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemsArray.append(newItem)
            
            self.SaveData()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (inputTextField) in
            inputTextField.placeholder = "Add a new item"
            textField = inputTextField
        }
        
        alert.addAction(alertAction)
        present(alert,animated: true,completion: nil)
    
    }
    
    func SaveData(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemsArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding data")
        }
    }
    
    func RetrieveData(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemsArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        RetrieveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem", for: indexPath)

        // Configure the cell...
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        let item = itemsArray[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = item.done == true ? .checkmark : .none
        SaveData()
        
    }
 
}
