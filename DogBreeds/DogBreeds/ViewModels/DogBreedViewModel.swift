//
//  DogBreedViewModel.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import SwiftUI

enum FetchState {
    case loading
    case fetched([DogBreed])
    case error(Error)
}

@MainActor
class DogBreedsViewModel: ObservableObject {
    @Published var fetchState: FetchState = .loading
    private let apiService: DogAPIServiceProtocol

    init(apiService: DogAPIServiceProtocol = DogAPIService()) {
        self.apiService = apiService
    }

    func fetchDogBreeds() async {
        do {
            fetchState = .loading
            let breeds = try await apiService.fetchDogBreeds()
            // TODO: Filter out breeds with no displayable name if needed
            fetchState = .fetched(breeds)
        } catch {
            fetchState = .error(error)
        }
    }
}
