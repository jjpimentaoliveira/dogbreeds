//
//  MockDogAPIService.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

class MockDogAPIService: DogAPIServiceProtocol {
    var responseData: [DogBreed] = []
    var dogBreedFetchError: DogAPIServiceError? = nil
    var imageFetchError: DogAPIServiceError? = nil
    var didCallFetchDogsBreeds = false
    var didCallFetchBreedImage = false

    func fetchDogBreeds(
        with order: SortOrder,
        page: Int
    ) async throws -> [DogBreed] {
        didCallFetchDogsBreeds = true

        if let dogBreedFetchError {
            throw dogBreedFetchError
        }

        return responseData
    }

    func fetchBreedImage(for imageID: String) async throws -> URL {
        didCallFetchBreedImage = true

        if let imageFetchError {
            throw imageFetchError
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
