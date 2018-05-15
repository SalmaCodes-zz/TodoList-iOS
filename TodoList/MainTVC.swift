//
//  MainTVC.swift
//  TodoList
//
//  Created by Salma Suliman on 5/14/18.
//  Copyright © 2018 SS. All rights reserved.
//

import UIKit
import CoreData

class MainTVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var items = [ItemEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
    }
    
    func fetchAllItems(){
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        do {
            let results = try context.fetch(itemRequest)
            items = results as! [ItemEntity]
        } catch {
            print("\(error)")
        }
    }
    
    // MARK: - Prepare Segue to AddItemVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navCtrl = segue.destination as! UINavigationController
        let addItemVC = navCtrl.topViewController as! AddItemVC
        addItemVC.delegate = self
        
        if sender is IndexPath {
            let idx = sender as! IndexPath
            let item = items[idx.row]
            addItemVC.date = item.date
            addItemVC.itemText = item.item
            addItemVC.notesText = item.notes
            addItemVC.indexPath = idx
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.itemLabel.text = items[indexPath.row].item
        cell.notesLabel.text = items[indexPath.row].notes
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        cell.dateLabel.text = dateFormatter.string(from: items[indexPath.row].date!)
        cell.checkLabel.isHidden = !items[indexPath.row].check
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.check = !item.check
        saveContext()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, indexPath) in
            let item = self.items[indexPath.row]
            self.context.delete(item)
            self.saveContext()
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") {
            (action, indexPath) in
            self.performSegue(withIdentifier: "toAddItem", sender: indexPath)
        }
        edit.backgroundColor = UIColor.green
        
        return [delete, edit]
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
}

extension MainTVC: AddItemDelegate {
    func addItem(item: String, notes: String, at date: Date, indexPath: IndexPath?) {
        print("Item", item, "Notes", notes, "Date", date)
        
        if let idx = indexPath {
            let it = items[idx.row]
            it.item = item
            it.notes = notes
            it.date = date
        } else {
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "ItemEntity", into: context) as! ItemEntity
            newItem.item = item
            newItem.notes = notes
            newItem.date = date
            newItem.check = false
            items.append(newItem)
        }

        saveContext()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
