//
//  MockDogAPIService.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

class MockDogAPIService: DogAPIServiceProtocol {
    func fetchDogBreeds(completion: @escaping (Result<[DogBreed], DogAPIServiceError>) -> Void) {
        let mockData: [DogBreed] = [
            DogBreed(id: 1, name: "Husky"),
            DogBreed(id: 2, name: "Chihuahua")
        ]
        completion(.success(mockData))
    }
}

