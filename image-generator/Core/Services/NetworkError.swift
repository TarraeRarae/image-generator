//
//  NetworkError.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

enum NetworkError: Error {
    case badRequest
    case error(String)
    case unableToDecodeData
    case dublicatedRequest

    var localizedDescription: String {
        switch self {
        case .badRequest:
            return Constants.badRequestDescription
        case .error(let error):
            return error
        case .unableToDecodeData:
            return Constants.unableToDecodeDataDescription
        case .dublicatedRequest:
            return Constants.dublicatedRequestDescription
        }
    }
}

// MARK: - Constants

private extension NetworkError {

    enum Constants {
        static let badRequestDescription = "Неверный запрос"
        static let unableToDecodeDataDescription = "Ошибка обработки ответа от сервера"
        static let dublicatedRequestDescription = "Вы уже отправляли этот запрос"
    }
}
