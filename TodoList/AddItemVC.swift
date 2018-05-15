//
//  AddItemVC.swift
//  TodoList
//
//  Created by Salma Suliman on 5/14/18.
//  Copyright © 2018 SS. All rights reserved.
//

import UIKit

protocol AddItemDelegate: class {
    func addItem(item: String, notes: String, at date: Date)
}

class AddItemVC: UIViewController {

    var delegate: AddItemDelegate?
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AddItemButtonPressed(_ sender: UIButton) {
        print("SUP")
        print(itemTextField.text!)
       // print(ItemTextField.text!)
        delegate?.addItem(item: itemTextField.text!,
                          notes: notesTextField.text!,
                          at: dateField.date)
    }
    
}

