//
//  ImageGenerationRequest.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import Foundation

struct ImageGenerationRequest: Request {

    // MARK: State

    var baseUrl: String = "https://dummyimage.com/"

    var path: String = ""

    var parameters: [String : String] {
        [:]
    }

    // MARK: Lifecycle

    init(
        size: (width: Int, height: Int),
        text: String
    ) {
        baseUrl += "\(size.width)x\(size.height)&text=\(text)"
    }

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}
