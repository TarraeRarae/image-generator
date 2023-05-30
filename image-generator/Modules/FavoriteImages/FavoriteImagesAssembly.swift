//
//  FavoriteImagesAssembly.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import UIKit

final class FavoriteImagesAssembly {

    // MARK: Create controller

    func createController() -> UIViewController {
        let presenter = createPresenter()
        let controller = FavoriteImagesViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }
}

// MARK: - Private API

private extension FavoriteImagesAssembly {

    func createPresenter() -> IFavoriteImagesPresenter {
        let generatedImagesLocalService = createGeneratedImageLocalService()
        return FavoriteImagesPresenter(generatedImagesLocalService: generatedImagesLocalService)
    }

    func createGeneratedImageLocalService() -> IGeneratedImagesLocalService {
        GeneratedImagesLocalService()
    }
}
