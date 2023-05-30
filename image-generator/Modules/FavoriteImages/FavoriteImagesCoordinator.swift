//
//  FavoriteImagesCoordinator.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import UIKit

final class FavoriteImagesCoordinator {

    // MARK: Dependencies
    
    private let assembly = FavoriteImagesAssembly()

    // MARK: Start flow

    func startFlow() -> UIViewController {
        UINavigationController(rootViewController: assembly.createController())
    }
}
