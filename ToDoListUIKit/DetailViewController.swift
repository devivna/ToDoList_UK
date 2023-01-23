//
//  DetailViewController.swift
//  ToDoListUIKit
//
//  Created by Students on 23.01.2023.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var itemField: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        let isPresentedInAddMode = presentingViewController is UINavigationController
        
        if isPresentedInAddMode {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }

}
