//
//  ImageGenerationAssembly.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

final class ImageGenerationAssembly {

    // MARK: Create controller

    func createController() -> UIViewController {
        let presenter = createPresenter()
        let controller = ImageGenerationViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }
}

// MARK: - Private API

private extension ImageGenerationAssembly {

    func createPresenter() -> IImageGenerationPresenter {
        let imageGenerationService = createImageGenerationService()
        let generatedImagesLocalService = createGeneratedImagesLocalService()
        return ImageGenerationPresenter(
            imageGenerationService: imageGenerationService,
            generatedImagesLocalService: generatedImagesLocalService
        )
    }

    func createImageGenerationService() -> IImageGenerationService {
        let requestProcessor = GenerateImageRequestProcessor()
        return ImageGenerationService(requestProcessor: requestProcessor)
    }

    func createGeneratedImagesLocalService() -> IGeneratedImagesLocalService {
        GeneratedImagesLocalService()
    }
}
