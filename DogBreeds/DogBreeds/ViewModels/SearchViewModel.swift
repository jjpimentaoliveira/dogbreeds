//
//  SearchViewModel.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 30/09/2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var filteredBreeds: [DogBreed] = []

    func filterBreeds(
        by query: String,
        in breeds: [DogBreed]
    ) {
        if query.isEmpty {
            filteredBreeds = breeds
        } else {
            print("Search query: \(query)")
            filteredBreeds = breeds.filter { breed in
                return breed.name.range(of: query, options: .caseInsensitive) != nil
            }
        }
    }
}
