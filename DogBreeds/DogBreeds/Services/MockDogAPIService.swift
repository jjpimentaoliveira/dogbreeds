//
//  MockDogAPIService.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

class MockDogAPIService: DogAPIServiceProtocol {
    var responseData: [DogBreed] = []
    var errorResponse: DogAPIServiceError? = nil
    var didCallFetchDogsBreeds = false
    var didCallFetchBreedImage = false

    func fetchDogBreeds() async throws -> [DogBreed] {
        didCallFetchDogsBreeds = true

        if let errorResponse {
            throw errorResponse
        }

        return responseData
    }

    func fetchBreedImage(for imageID: String) async throws -> URL {
        didCallFetchBreedImage = true

        if let errorResponse {
            throw errorResponse
        }

        if
            let baseURL,
            let url = URL(string: "\(baseURL)/v1/images/\(imageID)")
        {
            return url
        }

        throw DogAPIServiceError.invalidResponse
    }
}
