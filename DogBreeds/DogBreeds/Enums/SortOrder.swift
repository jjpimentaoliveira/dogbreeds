//
//  SortOrder.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 29/09/2023.
//

enum SortOrder: String {
    case ascending = "ASC"
    case descending = "DESC"

    var icon: String {
        switch self {
        case .ascending:
            return "arrow.up.circle"
        case .descending:
            return "arrow.down.circle"
        }
    }
}
