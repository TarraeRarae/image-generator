//
//  ImageGenerationCoordinator.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

final class ImageGenerationCoordinator {

    // MARK: Dependencies
    
    private let assembly = ImageGenerationAssembly()

    // MARK: Start flow

    func startFlow() -> UIViewController {
        UINavigationController(rootViewController: assembly.createController())
    }
}
