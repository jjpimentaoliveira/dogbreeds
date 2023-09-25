//
//  DogBreedViewModel.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import SwiftUI

class DogBreedsViewModel: ObservableObject {
    @Published var dogBreeds: [DogBreed] = []
    private let apiService: DogAPIServiceProtocol

    init(apiService: DogAPIServiceProtocol = DogAPIService()) {
        self.apiService = apiService
    }

    func fetchDogBreeds() {
        apiService.fetchDogBreeds { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let breeds):
                    self?.dogBreeds = breeds
                case .failure(let error):
                    print("fetchDogBreeds failure: \(error)")
                }
            }
        }
    }
}
