//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    
    //MARK - Add new items
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let newItem = Item(context: self.context)
        newItem.title = "Hey Aman complete Data persistance today"
        newItem.isChecked = false
        self.itemArray.append(newItem)
        self.saveItems()
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        
        //        if itemArray[indexPath.row].isChecked {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        //above can be refactored using the ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if itemArray[indexPath.row].isChecked {
        //            itemArray[indexPath.row].isChecked = false
        //        } else {
        //            itemArray[indexPath.row].isChecked = true
        //        }
        
        // above can be refactored as follows
        
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Model manipulation methods
    
    func saveItems () {
        do {
            try self.context.save()
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        // let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try self.context.fetch(request)
        } catch {
            print("error loading data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}


//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request: NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)

    }

   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
