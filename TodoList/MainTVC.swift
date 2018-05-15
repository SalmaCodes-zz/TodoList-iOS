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
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.itemLabel.text = items[indexPath.row].item
        cell.notesLabel.text = items[indexPath.row].notes
        cell.dateLabel.text = items[indexPath.row].date?.description
        cell.checkLabel.isHidden = !items[indexPath.row].check
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.check = !item.check
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
}

extension MainTVC: AddItemDelegate {
    func addItem(item: String, notes: String, at date: Date) {
        print("Item", item, "Notes", notes, "Date", date)
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ItemEntity", into: context) as! ItemEntity
        newItem.item = item
        newItem.notes = notes
        newItem.date = date
        newItem.check = false
        items.append(newItem)
        if context.hasChanges {
            do {
                try context.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
