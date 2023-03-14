//
//  ViewController.swift
//  ToDoListUIKit
//
//  Created by Students on 21.01.2023.
//

import UIKit
import UserNotifications

class ListViewController: UIViewController {
    
    // create a connection for the TableView
    //      register cell in the IB
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var addBarButton: UIBarButtonItem!
    
    // set array of data to hold information in the cells
    var toDoItems = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        authorizeLocalNotifications()
    }
    
    // set unique value for every notifications
    func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        
        // create content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badgeNumber
        content.sound = sound
        
        // create trigger -> need dateComponents
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        dateComponents.second = 00 // set seconds to 0 : not count second in out time
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // create request -> need identifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger?
        let notificationID = UUID().uuidString
        // notificationID from AppDelegate func willPresent
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //Register request with the notification center -> request: UNNotificationRequest
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification schedule \(notificationID), title: \(content.title)")
            }
        }
        
        return notificationID
    }
    
    func authorizeLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
            
            guard error == nil else {
                print("😡 Error: \(error!.localizedDescription)")
                return
            }
            
            if granted {
                print("✅ Notification allowed")
            } else {
                print("❌ Notification NOT allowed")
            }
        }
    }
    
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appending(path: "items").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else { return }
        let jsonDecoder = JSONDecoder()
        do {
            toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("Error: Could not load data \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appending(path: "items").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(toDoItems)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("Error: Could not save data \(error.localizedDescription)")
        }
        
        let toDoItem = toDoItems.first!
        let notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "Subtitle", body: toDoItem.note, badgeNumber: nil, sound: .default, date: toDoItem.date)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destination = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow
            destination.item = toDoItems[index!.row]
        } else {
            if let index = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: index, animated: false)
            }
        }
    }
    
    @IBAction func umwing(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        if let index = tableView.indexPathForSelectedRow {
            toDoItems[index.row] = source.item
            tableView.reloadRows(at: [index], with: .automatic)
        } else {
            let newIndex = IndexPath(row: toDoItems.count, section: 0)
            toDoItems.append(source.item)
            tableView.insertRows(at: [newIndex], with: .bottom)
            tableView.scrollToRow(at: newIndex, at: .bottom, animated: true)
        }
        saveData()
    }
    
    @IBAction func editButtonPresed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            // not editing
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            // when editing
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
        
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
}

