//
//  ListTableViewCell.swift
//  ToDoListUIKit
//
//  Created by Students on 15.03.2023.
//

import UIKit

protocol ListTableViewDelegate: class {
    func checkBoxToggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {

    weak var delegate: ListTableViewDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
    
}
