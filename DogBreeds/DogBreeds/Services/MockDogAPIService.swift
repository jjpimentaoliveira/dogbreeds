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

    func fetchDogBreeds() async throws -> [DogBreed] {
        didCallFetchDogsBreeds = true

        if let errorResponse {
            throw errorResponse
        }

        return responseData
    }
}

