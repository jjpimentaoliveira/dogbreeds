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

    func fetchDogBreeds() async throws -> [DogBreed] {
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
            throw DogAPIServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(
            apiKey,
            forHTTPHeaderField: "x-api-key"
        )

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Check if we can successfully convert the response from URLResponse? into HTTPURLResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                throw DogAPIServiceError.invalidResponse
            }

            // Check if request was successfully processed
            guard (200...299).contains(httpResponse.statusCode) else {
                throw DogAPIServiceError.invalidStatusCode(httpResponse.statusCode)
            }

            // Check if data was returned
            guard !data.isEmpty else {
                throw DogAPIServiceError.noDataReturned
            }

            let breeds = try JSONDecoder().decode([DogBreed].self, from: data)

            return breeds
        } catch {
            throw DogAPIServiceError.decodingError(error)
        }
    }
}
