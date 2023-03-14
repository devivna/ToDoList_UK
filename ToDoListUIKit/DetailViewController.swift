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
    
    @IBOutlet weak var switchRemainder: UISwitch!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    let dataPickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    let notesHeight: CGFloat = 200
    let defaultHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item == nil {
            item = ToDoItem(name: "", date: Date(), note: "", reminderSet: false)
        }
        
        updateUserInterface()
    }

    func updateUserInterface() {
        itemField.text = item.name
        datePicker.date = item.date
        noteView.text = item.note
        switchRemainder.isOn = item.reminderSet
        dataLabel.text = "Jan 01, 2023 0:00 AM"
       
        dataLabel.textColor = (switchRemainder.isOn ? .black : .gray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        item = ToDoItem(
            name: itemField.text!,
            date: datePicker.date,
            note: noteView.text,
            reminderSet: switchRemainder.isOn
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

    @IBAction func switchChanged(_ sender: UISwitch) {
        dataLabel.textColor = switchRemainder.isOn ? .black : .gray
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension DetailViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dataPickerIndexPath:
            return switchRemainder.isOn ? datePicker.frame.height : 0
        case notesIndexPath:
            return notesHeight
        default:
            return defaultHeight
        }
    }
}
