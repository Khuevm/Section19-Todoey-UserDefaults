//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    // MARK: - IBOutlet
    
    // MARK: - Variable
    var items: [Item] = []
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(dataFilePath!)
        loadItems()
    }
    
    // MARK: - IBAction
    @IBAction func addButtonDidTap(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen if user tap the Add Item Button
            if textField.text?.trimmingCharacters(in: .whitespaces) != "" {
                let newItem = Item(title: textField.text!)
                self.items.append(newItem)
                
                self.saveItems()
                self.tableView.reloadData()
            }
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.isDone ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    // MARK: - Helper
    func saveItems(){
//                Save data in NSUserDefault
//                self.defaults.set(self.items, forKey: "TodoListArray")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding data \(error)")
        }
    }
    
    func loadItems() {
//        Load data in NSUserDefault
//        if let safeItems = defaults.array(forKey: "TodoListArray") as? [Item] {
//            items = safeItems
//        }
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding data \(error)")
            }
        }
    }
}


