//
//  DetailViewController.swift
//  ToDoListUIKit
//
//  Created by Students on 23.01.2023.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var itemField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!

    var item: ToDoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item == nil {
            item = ToDoItem(name: "", date: Date(), note: "")
        }
        
        itemField.text = item.name
        datePicker.date = item.date
        noteView.text = item.note
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        item = ToDoItem(
            name: itemField.text!,
            date: datePicker.date,
            note: noteView.text
        )
//        item.name = itemField.text!
//        item.date = datePicker.date
//        item.note = noteView.text
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        let isPresentedAddMode = presentingViewController is UINavigationController
        
        if isPresentedAddMode {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

}
