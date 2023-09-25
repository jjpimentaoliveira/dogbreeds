//
//  DogAPIService.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

enum DogAPIServiceError: Error {
    case decodingError(Error)
    case invalidResponse
    case invalidStatusCode(Int)
    case invalidURL
    case networkError(Error)
    case noDataReturned
}

class DogAPIService: DogAPIServiceProtocol {

    private let apiKey = "live_FIpbA6C1hIBuaR24GMvc0TQ35YYCuIPD3v3T1Tnu5NWCEAwNikaWqeRinX180Zw5"

    func fetchDogBreeds(completion: @escaping (Result<[DogBreed], DogAPIServiceError>) -> Void) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.thedogapi.com"
        components.path = "/v1/breeds"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "100"),
            URLQueryItem(name: "has_breeds", value: "1")
        ]

        // Check if URL is valid
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(
            apiKey,
            forHTTPHeaderField: "x-api-key"
        )

        URLSession.shared.dataTask(with: request) { data, response, error in

            // Check if we received a network error
            if let error {
                completion(.failure(.networkError(error)))
                return
            }

            // Check if we can successfully convert the response from URLResponse? into HTTPURLResponse
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            // Check if request was successfully processed
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidStatusCode(response.statusCode)))
                return
            }

            // Check if data was returned
            guard let data else {
                completion(.failure(.noDataReturned))
                return
            }

            do {
                let decoder = JSONDecoder()
                let breeds = try decoder.decode([DogBreed].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(breeds))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
