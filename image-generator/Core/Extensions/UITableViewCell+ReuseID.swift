//
//  UITableViewCell+ReuseID.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

extension UITableViewCell {

    static var reuseId: String {
        String(describing: Self.self)
    }
}
