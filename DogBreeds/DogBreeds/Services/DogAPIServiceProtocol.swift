//
//  DogAPIServiceProtocol.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

protocol DogAPIServiceProtocol {
    var apiKey: String { get }
    var baseURL: URL? { get }

    func fetchDogBreeds() async throws -> [DogBreed]
    func fetchBreedImage(for imageID: String) async throws -> URL
}

extension DogAPIServiceProtocol {
    var apiKey: String {
        return "live_FIpbA6C1hIBuaR24GMvc0TQ35YYCuIPD3v3T1Tnu5NWCEAwNikaWqeRinX180Zw5"
    }

    var baseURL: URL? {
        return URL(string: "https://api.thedogapi.com")
    }
}
