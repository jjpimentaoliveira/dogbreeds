//
//  MainViewModel.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    private let apiService: DogAPIServiceProtocol
    private var currentPage = 0

    @Published var isLoadingNextPage = false
    @Published var fetchState: FetchState = .loading
    @Published var sortedBreeds: [DogBreed] = []

    init(apiService: DogAPIServiceProtocol = DogAPIService()) {
        self.apiService = apiService
    }

    func fetchInitialDogBreeds(with order: SortOrder) async {

        print("📃 Fetching first breeds..")

        currentPage = 0

        do {
            let breeds = try await apiService.fetchDogBreeds(with: order, page: currentPage)
            let updatedBreeds = try await updateImageURLs(forBreeds: breeds)
            sortedBreeds.append(contentsOf: sortBreeds(updatedBreeds, order: order))

            fetchState = .fetched(sortedBreeds)
        } catch {
            print("⚠️ Failed to fetch initial breeds. Error: \(error)")
            fetchState = .error(error)
        }
    }

    func loadNextPage(with order: SortOrder) async {

        guard isLoadingNextPage == false else { return }

        print("📃 Fetching next page...")

        currentPage += 1
        isLoadingNextPage = true

        do {
            let nextPageBreeds = try await apiService.fetchDogBreeds(with: order, page: currentPage)
            let updatedBreeds = try await updateImageURLs(forBreeds: nextPageBreeds)
            sortedBreeds.append(contentsOf: sortBreeds(updatedBreeds, order: order))

            fetchState = .fetched(sortedBreeds)
            isLoadingNextPage = false
        } catch {
            print("⚠️ Failed to load next page. Error: \(error)")
            currentPage -= 1
            isLoadingNextPage = false
        }
    }

    func shouldLoadNextPage(breed: DogBreed) -> Bool {
        return sortedBreeds.last?.id == breed.id
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
        print("Clearing all saved breeds...")
        sortedBreeds.removeAll()
    }

    func sortBreeds(
        _ breeds: [DogBreed],
        order: SortOrder
    ) -> [DogBreed] {
        return breeds.sorted {
            switch order {
            case .ascending:
                return $0.name.caseInsensitiveCompare($1.name) == .orderedAscending
            case .descending:
                return $0.name.caseInsensitiveCompare($1.name) == .orderedDescending
            }
        }
    }
}
