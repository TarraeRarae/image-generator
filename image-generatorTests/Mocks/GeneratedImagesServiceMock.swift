//
//  GeneratedImagesServiceMock.swift
//  image-generatorTests
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import Foundation

@testable import image_generator

final class GeneratedImagesServiceMock: IGeneratedImagesLocalService {

    var invokedIsModelSaved: Bool = false
    var invokedIsModelSavedCount: Int = 0
    var isModelSavedReturnValue: Bool = true

    func isModelSaved(_ model: image_generator.GeneratedImageModel) -> Bool {
        invokedIsModelSaved = true
        invokedIsModelSavedCount += 1
        return isModelSavedReturnValue
    }
    
    func isModelSaved(_ requestBaseUrl: String) -> Bool {
        invokedIsModelSaved = true
        invokedIsModelSavedCount += 1
        return isModelSavedReturnValue
    }

    var invokedSave: Bool = false
    var invokedSaveCount: Int = 0
    
    func save(_ model: GeneratedImageModel, _ completion: @escaping (Result<Void, LocalStorageError>) -> Void) {
        invokedSave = true
        invokedSaveCount += 1
    }

    var invokedFetchDataCompletionResult: Result<[GeneratedImageModel], LocalStorageError> = .success([])
    var invokedFetchData: Bool = true
    var invokedFetchDataCount: Int = 0
    
    func fetchData(_ completion: @escaping (Result<[GeneratedImageModel], LocalStorageError>) -> Void) {
        invokedFetchData = true
        invokedFetchDataCount += 1
        completion(invokedFetchDataCompletionResult)
    }

    var invokedDeleteData: Bool = true
    var invokedDeleteDataCount: Int = 0
    
    func deleteData(with model: GeneratedImageModel, _ completion: @escaping (Result<Void, LocalStorageError>) -> Void) {
        invokedDeleteData = true
        invokedDeleteDataCount += 1
    }
}
