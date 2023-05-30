//
//  FavoriteImagesControllerMock.swift
//  image-generatorTests
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import Foundation

@testable import image_generator

final class FavoriteImagesControllerMock: IFavoriteImagesView {
    
    var invokedConfigure: Bool = false
    var invokedConfigreCount: Int = 0

    func configure(with cellModels: [TableCellModel]) {
        invokedConfigure = true
        invokedConfigreCount += 1
    }

    var invokedShowCommonErrorAlert: Bool = false
    var invokedShowCommonErrorAlertCount: Int = 0
    var invokedShowCommonErrorAlertAction: () -> Void = {}
    
    func showCommonErrorAlert(title: String, message: String?) {
        invokedShowCommonErrorAlert = true
        invokedShowCommonErrorAlertCount += 1
        invokedShowCommonErrorAlertAction()
    }

    var invokedDeleteData: Bool = false
    var invokedDeleteDataCount: Int = 0

    func deleteData(with uuid: UUID) {
        invokedDeleteData = true
        invokedDeleteDataCount += 1
    }
}
