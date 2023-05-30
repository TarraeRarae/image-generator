//
//  TableViewCell.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

class TableViewCell: UITableViewCell, ConfigurableItem {

    func configure(_ params: Any) {
        fatalError("It's the base table view cell. You should inherit from it")
    }
}
