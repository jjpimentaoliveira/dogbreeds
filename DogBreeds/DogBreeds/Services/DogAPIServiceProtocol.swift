//
//  DogAPIServiceProtocol.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

protocol DogAPIServiceProtocol {
    func fetchDogBreeds() async throws -> [DogBreed]
    func fetchBreedImage(for imageID: String) async throws -> URL
}
