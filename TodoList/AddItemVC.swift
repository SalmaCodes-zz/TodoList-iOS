//
//  AddItemVC.swift
//  TodoList
//
//  Created by Salma Suliman on 5/14/18.
//  Copyright © 2018 SS. All rights reserved.
//

import UIKit

protocol AddItemDelegate: class {
    func addItem(item: String, notes: String, at date: Date, indexPath: IndexPath?)
}

class AddItemVC: UIViewController {
    
    var delegate: AddItemDelegate?
    
    var indexPath: IndexPath?
    var itemText: String?
    var notesText: String?
    var date: Date?
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTextField.text = itemText
        notesTextField.text = notesText
        if let d = date {
            dateField.setDate(d, animated: true)
            button.setTitle("Edit Item", for: .normal)
        }
    }
    
    @IBAction func AddItemButtonPressed(_ sender: UIButton) {
        delegate?.addItem(item: itemTextField.text!,
                          notes: notesTextField.text!,
                          at: dateField.date, indexPath: indexPath)
    }
}


