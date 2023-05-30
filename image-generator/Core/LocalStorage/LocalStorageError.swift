//
//  LocalStorageError.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

enum LocalStorageError: Error {
    case unableToSaveData
    case unableToFetchData
    case unableToDeleteData

    var localizedDescription: String {
        switch self {
        case .unableToSaveData:
            return Constants.unableToSaveDataDescription
        case .unableToFetchData:
            return Constants.unableToFetchDataDescription
        case .unableToDeleteData:
            return Constants.unableToDeleteDataDescription
        }
    }
}

// MARK: - Constants

private extension LocalStorageError {

    enum Constants {
        static let unableToSaveDataDescription = "Невозможно сохранить данные. Повторите попытку"
        static let unableToFetchDataDescription = "Невозможно загрузить данные. Повторите попытку"
        static let unableToDeleteDataDescription = "Невозможно удалить данные. Повторите попытку"
    }
}
