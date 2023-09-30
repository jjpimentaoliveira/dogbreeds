//
//  DogBreedsTests.swift
//  DogBreedsTests
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import XCTest
@testable import DogBreeds

final class DogBreedsTests: XCTestCase {
    var viewModel: MainViewModel?

    @MainActor override func setUp() {
        super.setUp()
        viewModel = MainViewModel(apiService: MockDogAPIService())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    @MainActor func testShouldLoadNextPage() {
        guard let viewModel else {
            XCTFail()
            return
        }

        viewModel.sortedBreeds = [DogBreed(id: 1), DogBreed(id: 2), DogBreed(id: 3)]

        let breedToTriggerLoad = DogBreed(id: 3)
        XCTAssertTrue(viewModel.shouldLoadNextPage(breed: breedToTriggerLoad))

        let breedToNotTriggerLoad = DogBreed(id: 2)
        XCTAssertFalse(viewModel.shouldLoadNextPage(breed: breedToNotTriggerLoad))
    }

    func testFetchDogBreedsSuccess() {

        let mockService = MockDogAPIService()

        let responseData: [DogBreed] = [
            DogBreed(id: 1, name: "Husky"),
            DogBreed(id: 2, name: "Chihuahua")
        ]

        mockService.responseData = responseData

        Task {
            await viewModel?.fetchInitialDogBreeds(with: .ascending)
            XCTAssertTrue(mockService.didCallFetchDogsBreeds)

            if case .fetched(let breeds) = await viewModel?.fetchState {
                XCTAssertEqual(breeds, responseData)
            } else {
                XCTFail("Expected .fetched state")
            }
        }
    }

    func testResponseParsing() async {
        let service = MockDogAPIService()
        service.responseData = [DogBreed(id: 1, name: "Husky")]

        do {
            let breeds = try await service.fetchDogBreeds(with: .ascending, page: 0)
            XCTAssertEqual(breeds.count, 1)
            XCTAssertEqual(breeds[0].id, 1)
            XCTAssertEqual(breeds[0].name, "Husky")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchDogBreedsFailure() {
        let mockService = MockDogAPIService()
        mockService.errorResponse = .invalidResponse

        Task {
            await viewModel?.fetchInitialDogBreeds(with: .ascending)

            XCTAssertTrue(mockService.didCallFetchDogsBreeds)

            if case .error(let error) = await viewModel?.fetchState {
                XCTAssertEqual(
                    error.localizedDescription,
                    DogAPIServiceError.invalidResponse.localizedDescription
                )
            } else {
                XCTFail("Expected .error state")
            }
        }
    }

    func testFetchBreedImageSuccess() async {
        let service = MockDogAPIService()
        service.responseData = [DogBreed(id: 1, name: "Husky")]

        do {
            let imageURL = try await service.fetchBreedImage(for: "1")
            XCTAssertEqual(imageURL, URL(string: "https://api.thedogapi.com/v1/images/1"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchBreedImageError() async {
        let service = MockDogAPIService()
        service.errorResponse = DogAPIServiceError.invalidResponse

        do {
            _ = try await service.fetchBreedImage(for: "1")
            XCTFail("Expected an error but received success")
        } catch {
            XCTAssertTrue(error is DogAPIServiceError)
            XCTAssertEqual(
                error.localizedDescription,
                DogAPIServiceError.invalidResponse.localizedDescription
            )
        }
    }

    @MainActor func testAscendingSort() {
        let unsortedBreeds = [
            DogBreed(id: 1, name: "Golden Retriever"),
            DogBreed(id: 2, name: "Dachshund"),
            DogBreed(id: 3, name: "Beagle"),
            DogBreed(id: 4, name: "Husky"),
            DogBreed(id: 5, name: "Chihuahua")
        ]

        let sortedBreeds = viewModel?.sortBreeds(unsortedBreeds, order: .ascending)
        XCTAssertEqual(sortedBreeds?.map { $0.name }, ["Beagle", "Chihuahua", "Dachshund", "Golden Retriever", "Husky"])
    }

    @MainActor func testDescendingSort() {
        let unsortedBreeds = [
            DogBreed(id: 1, name: "Golden Retriever"),
            DogBreed(id: 2, name: "Dachshund"),
            DogBreed(id: 3, name: "Beagle"),
            DogBreed(id: 4, name: "Husky"),
            DogBreed(id: 5, name: "Chihuahua")
        ]

        let sortedBreeds = viewModel?.sortBreeds(unsortedBreeds, order: .descending)
        XCTAssertEqual(sortedBreeds?.map { $0.name }, ["Husky", "Golden Retriever", "Dachshund", "Chihuahua", "Beagle"])
    }
}
