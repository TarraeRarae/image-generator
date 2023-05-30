//
//  ConfigurableItem.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

protocol ConfigurableItem: AnyObject {
    func configure(_ params: Any)
}
