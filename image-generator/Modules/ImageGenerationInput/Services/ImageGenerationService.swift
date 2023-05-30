//
//  ImageGenerationService.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import UIKit

protocol IImageGenerationService: AnyObject {
    func exectute(
        request: ImageGenerationRequest,
        completion: @escaping (Result<GeneratedImageModel, NetworkError>) -> Void
    )
}

final class ImageGenerationService: IImageGenerationService {

    // MARK: Dependencies

    private let requestProcessor: GenerateImageRequestProcessor

    // MARK: State

    private var cachedRequests = [ImageGenerationRequest]()

    // MARK: Lifecycle

    init(requestProcessor: GenerateImageRequestProcessor) {
        self.requestProcessor = requestProcessor
    }

    // MARK: IImageGenerationService

    func exectute(request: ImageGenerationRequest, completion: @escaping (Result<GeneratedImageModel, NetworkError>) -> Void) {
        if cachedRequests.contains(where: {
            $0.baseUrl == request.baseUrl && $0.parameters == request.parameters && $0.path == request.path
        }) {
            completion(.failure(.dublicatedRequest))
            return
        }
        cachedRequests.append(request)
        requestProcessor.sendRequest(request: request) { result in
            switch result {
            case .success(let data):
                guard UIImage(data: data) != nil else {
                    completion(.failure(.unableToDecodeData))
                    return
                }
                let response = GeneratedImageModel(uuid: UUID(), imageData: data, request: request)
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
