//
//  TableCellModel.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import Foundation

protocol TableCellModel {
    var uuid: UUID { get }
    var reuseId: String { get }
}
