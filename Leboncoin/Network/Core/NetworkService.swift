//
//  NetworkService.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

final class NetworkService {

    // MARK: - INTERNAL

    // MARK: Methods

    /// Init for dependency injection in order to test this class
    init(networkSession: URLSession = URLSession(configuration: .default)) {
        self.networkSession = networkSession
    }

    /// Method get and send data or error via callback
    func getNetworkResponse(with targetURL: URL, callback: @escaping (Result<Data, NetworkError>) -> Void) {

        // Avoid parallel network calls
        let task: URLSessionDataTask?
        task = networkSession.dataTask(with: targetURL) { (data, response, error) in

            // Putting code execution in main thread to ensure coordianation with UI
            DispatchQueue.main.async {

                // Ensure that network call return no error, else we send an error via callback
                guard error == nil else {
                    return callback(.failure(.hasError))
                }

                // Ensure that network call return a correct response format, else we send an error via callback
                guard let response = response as? HTTPURLResponse else {
                    return callback(.failure(.responseIsWrongType))
                }

                // Ensure that network call return a response status code 200, else we send an error via callback
                guard response.statusCode == 200 else {
                    return callback(.failure(.wrongStatusCode))
                }

                // Ensure that network call return a not empty data, else we send an error via callback
                guard let data = data else {
                    return callback(.failure(.noData))
                }

                // Finally, if all conditions passed, we send data via the callback
                callback(.success(data))

            }
        }
        task?.resume()
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let networkSession: URLSession
}
