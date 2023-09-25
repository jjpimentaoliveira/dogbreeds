//
//  DogBreedsTests.swift
//  DogBreedsTests
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import XCTest
@testable import DogBreeds

final class DogBreedsTests: XCTestCase {
    var viewModel: DogBreedsViewModel?
    let mockService: MockDogAPIService = MockDogAPIService()

    @MainActor override func setUp() {
        super.setUp()
        viewModel = DogBreedsViewModel(apiService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchDogBreedsSuccess() {
        let responseData: [DogBreed] = [
            DogBreed(id: 1, name: "Husky"),
            DogBreed(id: 2, name: "Chihuahua")
        ]
        mockService.responseData = responseData

        Task {
            await viewModel?.fetchDogBreeds()

            XCTAssertTrue(mockService.didCallFetchDogsBreeds)

            if case .fetched(let breeds) = await viewModel?.fetchState {
                XCTAssertEqual(breeds, responseData)
            } else {
                XCTFail("Expected .fetched state")
            }
        }
    }

    func testFetchDogBreedsFailure() {
        mockService.errorResponse = .invalidResponse

        Task {
            await viewModel?.fetchDogBreeds()

            XCTAssertTrue(mockService.didCallFetchDogsBreeds)

            if case .error(let error) = await viewModel?.fetchState {
                XCTAssertEqual(error.localizedDescription, DogAPIServiceError.invalidResponse.localizedDescription)
            } else {
                XCTFail("Expected .error state")
            }
        }
    }
}
