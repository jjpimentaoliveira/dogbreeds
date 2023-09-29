//
//  FetchState.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 29/09/2023.
//

enum FetchState {
    case loading
    case fetched([DogBreed])
    case error(Error)
}
