//
//  Request.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

protocol Request {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
}
