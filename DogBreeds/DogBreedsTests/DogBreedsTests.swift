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

    @MainActor override func setUp() {
        super.setUp()
        viewModel = DogBreedsViewModel(apiService: MockDogAPIService())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchDogBreedsSuccess() {

        let mockService = MockDogAPIService()

        let responseData: [DogBreed] = [
            DogBreed(id: 1, name: "Husky"),
            DogBreed(id: 2, name: "Chihuahua")
        ]

        mockService.responseData = responseData

        Task {
            await viewModel?.fetchDogBreeds(with: .ascending)

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
            let breeds = try await service.fetchDogBreeds(with: .ascending)
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
            await viewModel?.fetchDogBreeds(with: .ascending)

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
}
