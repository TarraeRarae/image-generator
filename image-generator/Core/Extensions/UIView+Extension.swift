//
//  UIView+Extension.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

extension UIView {

    func makeForLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
