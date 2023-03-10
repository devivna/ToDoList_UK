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

    var item: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item == nil {
            item = ""
        }
        itemField.text = item
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        item = itemField.text
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
