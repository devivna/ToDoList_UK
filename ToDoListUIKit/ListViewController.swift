//
//  ViewController.swift
//  ToDoListUIKit
//
//  Created by Students on 21.01.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    // create a connection for the TableView
    //      register cell in the IB
    @IBOutlet weak var tableView: UITableView!
    
    // set array of data to hold information in the cells
    var arrayOfData = [
    "Element 1",
    "Element 2",
    "Element 3",
    "Element 4",
    "Element 5"
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destination = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow
            destination.item = arrayOfData[index!.row]
        } else {
            if let index = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: index, animated: false)
            }
        }
    }
    
    @IBAction func umwing(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        if let index = tableView.indexPathForSelectedRow {
            arrayOfData[index.row] = source.item
            tableView.reloadRows(at: [index], with: .automatic)
        } else {
            let newIndex = IndexPath(row: arrayOfData.count, section: 0)
            arrayOfData.append(source.item)
            tableView.insertRows(at: [newIndex], with: .bottom)
            tableView.scrollToRow(at: newIndex, at: .bottom, animated: true)
        }
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrayOfData[indexPath.row]
        return cell
    }
}

