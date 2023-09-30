//
//  DogBreedsTests.swift
//  DogBreedsTests
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import XCTest
@testable import DogBreeds

final class DogBreedsTests: XCTestCase {
    var mainViewModel: MainViewModel?
    var mockService: MockDogAPIService = MockDogAPIService()
    var searchViewModel: SearchViewModel?

    @MainActor override func setUp() {
        super.setUp()
        mainViewModel = MainViewModel(apiService: mockService)
        searchViewModel = SearchViewModel()
    }

    override func tearDown() {
        mainViewModel = nil
        searchViewModel = nil
        super.tearDown()
    }

    @MainActor func testFetch_ShouldLoadNextPage() {
        guard let mainViewModel else {
            XCTFail()
            return
        }

        mainViewModel.sortedBreeds = [DogBreed(id: 1), DogBreed(id: 2), DogBreed(id: 3)]

        let breedToTriggerLoad = DogBreed(id: 3)
        XCTAssertTrue(mainViewModel.shouldLoadNextPage(breed: breedToTriggerLoad))

        let breedToNotTriggerLoad = DogBreed(id: 2)
        XCTAssertFalse(mainViewModel.shouldLoadNextPage(breed: breedToNotTriggerLoad))
    }

    func testFetch_Success() {
        let responseData: [DogBreed] = [
            DogBreed(id: 1, name: "Husky"),
            DogBreed(id: 2, name: "Chihuahua")
        ]

        mockService.responseData = responseData

        Task {
            await mainViewModel?.fetchInitialDogBreeds(with: .ascending)
            XCTAssertTrue(mockService.didCallFetchDogsBreeds)

            if case .fetched(let breeds) = await mainViewModel?.fetchState {
                XCTAssertEqual(breeds, responseData)
            } else {
                XCTFail("Expected .fetched state")
            }
        }
    }

    func testParsing_Success() async {
        mockService.responseData = [DogBreed(id: 1, name: "Husky")]

        do {
            let breeds = try await mockService.fetchDogBreeds(with: .ascending, page: 0)
            XCTAssertEqual(breeds.count, 1)
            XCTAssertEqual(breeds[0].id, 1)
            XCTAssertEqual(breeds[0].name, "Husky")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetch_Failure() {
        mockService.dogBreedFetchError = .invalidResponse

        Task {
            await mainViewModel?.fetchInitialDogBreeds(with: .ascending)

            XCTAssertTrue(mockService.didCallFetchDogsBreeds)

            if case .error(let error) = await mainViewModel?.fetchState {
                XCTAssertEqual(
                    error.localizedDescription,
                    DogAPIServiceError.invalidResponse.localizedDescription
                )
            } else {
                XCTFail("Expected .error state")
            }
        }
    }

    func testImageFetch_Success() async {
        mockService.responseData = [DogBreed(id: 1, name: "Husky")]

        do {
            let imageURL = try await mockService.fetchBreedImage(for: "1")
            XCTAssertEqual(imageURL, URL(string: "https://api.thedogapi.com/v1/images/1"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testImageFetch_Failure() async {
        mockService.dogBreedFetchError = nil
        mockService.imageFetchError = .invalidURL

        Task {
            await mainViewModel?.fetchInitialDogBreeds(with: .ascending)

            XCTAssertTrue(mockService.didCallFetchBreedImage)

            if case .error(let error) = await mainViewModel?.fetchState {
                XCTAssertEqual(
                    error.localizedDescription,
                    DogAPIServiceError.invalidURL.localizedDescription
                )
            } else {
                XCTFail("Expected .error state")
            }
        }
    }

    @MainActor func testSort_Ascending() {
        let unsortedBreeds = [
            DogBreed(id: 1, name: "Golden Retriever"),
            DogBreed(id: 2, name: "Dachshund"),
            DogBreed(id: 3, name: "Beagle"),
            DogBreed(id: 4, name: "Husky"),
            DogBreed(id: 5, name: "Chihuahua")
        ]

        let sortedBreeds = mainViewModel?.sortBreeds(unsortedBreeds, order: .ascending)
        XCTAssertEqual(sortedBreeds?.map { $0.name }, ["Beagle", "Chihuahua", "Dachshund", "Golden Retriever", "Husky"])
    }

    @MainActor func testSort_Descending() {
        let unsortedBreeds = [
            DogBreed(id: 1, name: "Golden Retriever"),
            DogBreed(id: 2, name: "Dachshund"),
            DogBreed(id: 3, name: "Beagle"),
            DogBreed(id: 4, name: "Husky"),
            DogBreed(id: 5, name: "Chihuahua")
        ]

        let sortedBreeds = mainViewModel?.sortBreeds(unsortedBreeds, order: .descending)
        XCTAssertEqual(sortedBreeds?.map { $0.name }, ["Husky", "Golden Retriever", "Dachshund", "Chihuahua", "Beagle"])
    }

    func testFilter_EmptyQuery() {
        let breeds = [
            DogBreed(id: 1, name: "Golden Retriever"),
            DogBreed(id: 2, name: "Dachshund"),
            DogBreed(id: 3, name: "Beagle"),
            DogBreed(id: 4, name: "Husky"),
            DogBreed(id: 5, name: "Chihuahua")
        ]
        searchViewModel?.filterBreeds(by: "", in: breeds)
        XCTAssertEqual(searchViewModel?.filteredBreeds.count, breeds.count)
    }

    func testFilter_MatchingQuery() {
        let breeds = [
            DogBreed(id: 1, name: "Golden Retriever"),
            DogBreed(id: 2, name: "Dachshund"),
            DogBreed(id: 3, name: "Beagle"),
            DogBreed(id: 4, name: "Husky"),
            DogBreed(id: 5, name: "Chihuahua")
        ]
        searchViewModel?.filterBreeds(by: "Golden", in: breeds)
        XCTAssertEqual(searchViewModel?.filteredBreeds.count ?? 0, 1)
    }

    func testFilter_NoMatchingQuery() {
        let breeds = [
            DogBreed(id: 1, name: "Golden Retriever"),
            DogBreed(id: 2, name: "Dachshund"),
            DogBreed(id: 3, name: "Beagle"),
            DogBreed(id: 4, name: "Husky"),
            DogBreed(id: 5, name: "Chihuahua")
        ]
        searchViewModel?.filterBreeds(by: "Pitbull", in: breeds)
        XCTAssertEqual(searchViewModel?.filteredBreeds.count, 0)
    }
}
