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
    private let baseURL = URL(string: "https://api.thedogapi.com")

    private func makeRequest<T: Decodable>(
        endpoint: String,
        parameters: [URLQueryItem] = [],
        responseType: T.Type = T.self
    ) async throws -> T {

        guard let baseURL else { throw DogAPIServiceError.invalidURL }

        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true)
        components?.queryItems = parameters

        // Check if URL is valid
        guard let url = components?.url else {
            throw DogAPIServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

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

            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch let decodingError as DecodingError {
            throw DogAPIServiceError.decodingError(decodingError)
        } catch {
            throw DogAPIServiceError.networkError(error)
        }
    }

    func fetchDogBreeds() async throws -> [DogBreed] {
        let endpoint = "/v1/breeds"
        let parameters: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "has_breeds", value: "1")
        ]

        do {
             let breeds: [DogBreed] = try await makeRequest(endpoint: endpoint, parameters: parameters)
             return breeds
         } catch {
             throw error
         }
    }

    func fetchBreedImage(for imageID: String) async throws -> URL {
        let endpoint = "/v1/images/\(imageID)"

        do {
            let breedImage: BreedImage = try await makeRequest(endpoint: endpoint)

            if
                let url = breedImage.url,
                let imageUrl = URL(string: url)
            {
                return imageUrl
            } else {
                throw DogAPIServiceError.invalidResponse
            }
        } catch {
            throw error
        }
    }
}
