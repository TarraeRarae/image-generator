//
//  ImageGenerationPresenter.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

protocol IImageGenerationPresenter: AnyObject {
    var view: IImageGenerationView? { get set }

    func viewDidLoad()
    func updateData(cellModels: [TableCellModel])
}

final class ImageGenerationPresenter: IImageGenerationPresenter {

    // MARK: Dependencies

    weak var view: IImageGenerationView?

    private let imageGenerationService: IImageGenerationService
    private let generatedImagesLocalService: IGeneratedImagesLocalService

    // MARK: State

    private lazy var textForRequest: String = ""

    // MARK: Lifecycle

    init(
        imageGenerationService: IImageGenerationService,
        generatedImagesLocalService: IGeneratedImagesLocalService
    ) {
        self.imageGenerationService = imageGenerationService
        self.generatedImagesLocalService = generatedImagesLocalService
    }

    // MARK: IImageNameInputPresenter

    func viewDidLoad() {
        setupData()
    }

    func updateData(cellModels: [TableCellModel]) {
        var newCellModels = [TableCellModel]()
        for index in 0..<cellModels.count {
            if let imageCellModel = cellModels[index] as? ImageTableViewCell.Model {
                if !generatedImagesLocalService.isModelSaved(imageCellModel.requestBaseUrl) {
                    let newImageCellModel = ImageTableViewCell.Model(
                        uuid: imageCellModel.uuid,
                        imageData: imageCellModel.imageData,
                        isSaved: false,
                        requestBaseUrl: imageCellModel.requestBaseUrl,
                        favoriteButtonAction: imageCellModel.favoriteButtonAction
                    )
                    newCellModels.append(newImageCellModel)
                    continue
                }
            }
            if let textFielCellModel = cellModels[index] as? TextFieldTableViewCell.Model {
                let newTextFielCellModel = TextFieldTableViewCell.Model(
                    textFieldText: textForRequest,
                    inputAction: textFielCellModel.inputAction
                )
                newCellModels.append(newTextFielCellModel)
                continue
            }
            newCellModels.append(cellModels[index])
        }
        view?.configure(with: newCellModels)
    }
}

// MARK: - Private API

private extension ImageGenerationPresenter {

    func setupData() {
        let buttonCellModel = MainButtonTableViewCell.Model(buttonTitle: Constants.buttonTitle) {
            self.tryToSendGenerateImageRequest()
        }

        let textFieldCellModel = TextFieldTableViewCell.Model(textFieldText: textForRequest) { input in
            self.textForRequest = input
        }

        view?.configure(with: [textFieldCellModel, buttonCellModel])
    }

    func appendImageCellModel(with model: GeneratedImageModel) {
        let imageCellModel = ImageTableViewCell.Model(
            uuid: model.uuid,
            imageData: model.imageData,
            isSaved: false,
            requestBaseUrl: model.request.baseUrl
        ) { [weak self] isSaved in
            if isSaved {
                self?.addToFavorites(model: model)
                return
            }
            self?.deleteFromFavorites(model: model)
        }
        DispatchQueue.main.async {
            self.view?.insertData(models: [IndexPath(item: 2, section: 0): imageCellModel])
        }
    }

    func updateImageCellModel(with model: GeneratedImageModel, isSaved: Bool) {
        let newModel = ImageTableViewCell.Model(
            uuid: model.uuid,
            imageData: model.imageData,
            isSaved: isSaved,
            requestBaseUrl: model.request.baseUrl
        ) { isSaved in
            if isSaved {
                self.addToFavorites(model: model)
                return
            }
            self.deleteFromFavorites(model: model)
        }
        DispatchQueue.main.async {
            self.view?.updateCellModel(with: newModel)
        }
    }
}

// MARK: - Actions

private extension ImageGenerationPresenter {

    func tryToSendGenerateImageRequest() {
        guard !textForRequest.isEmpty else {
            view?.showCommonErrorAlert(
                title: Constants.generationErrorAlertTitle,
                message: Constants.generationErrorAlertMessage
            )
            return
        }
        let request = ImageGenerationRequest(
            size: (width: Constants.imageSize, height: Constants.imageSize),
            text: textForRequest
        )

        if generatedImagesLocalService.isModelSaved(request.baseUrl) {
            self.view?.showCommonErrorAlert(
                title: Constants.dublicateRequestErrorAlertTitle,
                message: Constants.dublicateRequestErrorAlertMessage
            )
            return
        }

        imageGenerationService.exectute(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.appendImageCellModel(with: response)
            case .failure(let error):
                self?.showCommonErrorAlert(title: error.localizedDescription)
                return
            }
        }
    }

    func addToFavorites(model: GeneratedImageModel) {
        generatedImagesLocalService.save(model) { [weak self] result in
            switch result {
            case .success:
                self?.updateImageCellModel(with: model, isSaved: true)
            case .failure(let error):
                self?.showCommonErrorAlert(title: error.localizedDescription)
            }
        }
    }

    func deleteFromFavorites(model: GeneratedImageModel) {
        generatedImagesLocalService.deleteData(with: model) { [weak self] result in
            switch result {
            case .success:
                self?.updateImageCellModel(with: model, isSaved: false)
            case .failure(let error):
                self?.showCommonErrorAlert(title: error.localizedDescription)
            }
        }
    }

    func showCommonErrorAlert(title: String, message: String? = nil) {
        DispatchQueue.main.async {
            self.view?.showCommonErrorAlert(title: title, message: message)
        }
    }
}

// MARK: - Constants

private extension ImageGenerationPresenter {

    enum Constants {
        static let imageSize = 350
        static let generationErrorAlertTitle = "Unable to generate image"
        static let generationErrorAlertMessage = "Please, enter your request into text field"
        static let buttonTitle = "Generate image"
        static let dublicateRequestErrorAlertTitle = "This request already had been completed"
        static let dublicateRequestErrorAlertMessage = "Look at tab \"Favorites\""
    }
}
