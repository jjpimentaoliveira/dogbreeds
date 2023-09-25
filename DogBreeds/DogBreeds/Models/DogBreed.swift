//
//  DogBreed.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

struct DogBreed: Codable {
    let id: Int
    let bredFor: String?
    let breedGroup: String?
    let countryCode: String?
    let description: String?
    let height: DogSize?
    let history: String?
    let lifeSpan: String?
    let name: String?
    let origin: String?
    let referenceImageID: String?
    let temperament: String?
    let weight: DogSize?

    enum CodingKeys: String, CodingKey {
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case countryCode = "country_code"
        case description
        case height
        case history
        case id
        case lifeSpan = "life_span"
        case name
        case origin
        case referenceImageID = "reference_image_id"
        case temperament 
        case weight
    }

    init(
        id: Int,
        bredFor: String? = nil,
        breedGroup: String? = nil,
        countryCode: String? = nil,
        description: String? = nil,
        height: DogSize? = nil,
        history: String? = nil,
        lifeSpan: String? = nil,
        name: String? = nil,
        origin: String? = nil,
        referenceImageID: String? = nil,
        temperament: String? = nil,
        weight: DogSize? = nil
    ) {
        self.id = id
        self.bredFor = bredFor
        self.breedGroup = breedGroup
        self.countryCode = countryCode
        self.description = description
        self.height = height
        self.history = history
        self.lifeSpan = lifeSpan
        self.name = name
        self.origin = origin
        self.referenceImageID = referenceImageID
        self.temperament = temperament
        self.weight = weight
    }

    struct DogSize: Codable {
        let imperial: String?
        let metric: String?
    }
}
