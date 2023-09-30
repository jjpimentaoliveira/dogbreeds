//
//  DogBreed.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import Foundation

struct DogBreed: Codable, Equatable {
    let id: Int
    let bredFor: String?
    let breedGroup: String?
    let countryCode: String?
    let description: String?
    let height: DogSize?
    let history: String?
    var imageURL: URL?
    let lifeSpan: String?
    let name: String
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
        imageURL: URL? = nil,
        lifeSpan: String? = nil,
        name: String = "Unknown breed",
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
        self.imageURL = imageURL
        self.lifeSpan = lifeSpan
        self.name = name
        self.origin = origin
        self.referenceImageID = referenceImageID
        self.temperament = temperament
        self.weight = weight
    }

    struct DogSize: Codable, Equatable {
        let imperial: String?
        let metric: String?
    }
}

extension DogBreed {
    init(
        existingBreed: DogBreed,
        imageURL: URL?
    ) {
        self.init(
            id: existingBreed.id,
            bredFor: existingBreed.bredFor,
            breedGroup: existingBreed.breedGroup,
            countryCode: existingBreed.countryCode,
            description: existingBreed.description,
            height: existingBreed.height,
            history: existingBreed.history,
            imageURL: imageURL,
            lifeSpan: existingBreed.lifeSpan,
            name: existingBreed.name,
            origin: existingBreed.origin,
            referenceImageID: existingBreed.referenceImageID,
            temperament: existingBreed.temperament,
            weight: existingBreed.weight
        )
    }
}
