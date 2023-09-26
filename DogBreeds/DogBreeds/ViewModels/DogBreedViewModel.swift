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
            var breeds = try await apiService.fetchDogBreeds()

            try await fetchImageUrls(for: &breeds)

            fetchState = .fetched(breeds)
        } catch {
            fetchState = .error(error)
        }
    }

    private func fetchImageUrls(for breeds: inout [DogBreed]) async throws {
        try await withThrowingTaskGroup(of: DogBreed.self) { group in
            for breed in breeds {
                if let imageID = breed.referenceImageID {
                    group.addTask {
                        do {
                            let imageURL = try await self.apiService.fetchBreedImage(for: imageID)
                            let updatedBreed = DogBreed(existingBreed: breed, imageURL: imageURL)
                            return updatedBreed
                        } catch {
                            print("Error: \(error.localizedDescription) while fetching breed: \(breed.id) imageURL")
                            // Return the original breed
                            return breed
                        }
                    }
                } else {
                    group.addTask {
                        // No image ID, return the original breed
                        return breed
                    }
                }
            }

            var updatedBreeds: [DogBreed] = []
            for try await breed in group {
                updatedBreeds.append(breed)
            }

            breeds = updatedBreeds
        }
    }
}
