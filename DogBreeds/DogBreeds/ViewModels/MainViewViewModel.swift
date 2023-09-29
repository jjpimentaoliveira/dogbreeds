//
//  MainViewViewModel.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import SwiftUI

@MainActor
class MainViewViewModel: ObservableObject {
    @Published var fetchState: FetchState = .loading
    var sortedBreeds: [DogBreed] = []
    private let apiService: DogAPIServiceProtocol

    init(apiService: DogAPIServiceProtocol = DogAPIService()) {
        self.apiService = apiService
    }

    func fetchInitialDogBreeds(with order: SortOrder) async {
        do {
            fetchState = .loading
            let breeds = try await apiService.fetchDogBreeds(with: order)
            let updatedBreeds = try await updateImageURLs(forBreeds: breeds)
            sortedBreeds = sortBreeds(updatedBreeds, sortOrder: order)
            fetchState = .fetched(sortedBreeds)
        } catch {
            fetchState = .error(error)
        }
    }

    private func updateImageURLs(forBreeds breeds: [DogBreed]) async throws -> [DogBreed] {
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
                            return breed
                        }
                    }
                } else {
                    group.addTask {
                        return breed
                    }
                }
            }

            var updatedBreeds: [DogBreed] = []
            for try await breed in group {
                updatedBreeds.append(breed)
            }

            return updatedBreeds
        }
    }

    func clearAndFetchBreeds(with order: SortOrder) async {
        Task {
            await clearBreeds()
            await fetchInitialDogBreeds(with: order)
        }
    }

    private func clearBreeds() async {
        sortedBreeds.removeAll()
    }

    func sortBreeds(
        _ breeds: [DogBreed],
        order: SortOrder
    ) -> [DogBreed] {
        return breeds.sorted {
            switch order {
            case .ascending:
                return $0.name?.caseInsensitiveCompare($1.name ?? "") == .orderedAscending
            case .descending:
                return $0.name?.caseInsensitiveCompare($1.name ?? "") == .orderedDescending
            }
        }
    }
}
