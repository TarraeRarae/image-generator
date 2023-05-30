//
//  FavoriteImagesPresenter.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import Foundation

protocol IFavoriteImagesPresenter: AnyObject {
    var view: IFavoriteImagesView? { get set }

    func updateContent()
}

final class FavoriteImagesPresenter: IFavoriteImagesPresenter {

    // MARK: Dependencies

    weak var view: IFavoriteImagesView?

    private let generatedImagesLocalService: IGeneratedImagesLocalService

    // MARK: Lifecycle

    init(generatedImagesLocalService: IGeneratedImagesLocalService) {
        self.generatedImagesLocalService = generatedImagesLocalService
    }

    // MARK: IFavoriteImagesPresenter

    func updateContent() {
        loadContent { [weak self] data in
            if let data = data {
                self?.setupData(data: data)
            }
        }
    }
}

// MARK: - Private API

private extension FavoriteImagesPresenter {

    func setupData(data: [GeneratedImageModel]) {
        var cellModels = [TableCellModel]()
        for item in data {
            cellModels.append(ImageTableViewCell.Model(
                uuid: item.uuid,
                imageData: item.imageData,
                isSaved: true,
                requestBaseUrl: item.request.baseUrl
            ) { isSaved in
                if !isSaved {
                    self.deleteFromFavorites(model: item)
                }
            })
        }
        view?.configure(with: cellModels)
    }

    func loadContent(_ completion: @escaping ([GeneratedImageModel]?) -> Void) {
        generatedImagesLocalService.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                self?.showCommonErrorAlert(title: error.localizedDescription)
                completion(nil)
            }
        }
    }
}

// MARK: - Actions

private extension FavoriteImagesPresenter {

    func deleteFromFavorites(model: GeneratedImageModel) {
        generatedImagesLocalService.deleteData(with: model) { [weak self] result in
            switch result {
            case .success:
                self?.view?.deleteData(with: model.uuid)
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
