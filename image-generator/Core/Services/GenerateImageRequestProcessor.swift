//
//  GenerateImageRequestProcessor.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import Foundation
import UIKit

final class GenerateImageRequestProcessor {

    func sendRequest<R: Request>(request: R, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard var urlComponents = URLComponents(string: request.baseUrl) else {
            print("Incorrect base url at request \(R.self)")
            return
        }

        urlComponents.queryItems = []

        for parameter in request.parameters {
            let urlQueryParameter = URLQueryItem(
                name: parameter.key,
                value: parameter.value
            )
            urlComponents.queryItems?.append(urlQueryParameter)
        }

        guard let url = urlComponents.url else {
            print("Incorrect url in urlComponents \(R.self)")
            return
        }

        let urlRequest = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.error(error.localizedDescription)))
            }
            guard let data = data else {
                completion(.failure(.badRequest))
                return
            }
            completion(.success(data))
        }

        task.resume()
    }
}
