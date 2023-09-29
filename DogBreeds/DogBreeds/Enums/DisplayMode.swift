//
//  DisplayMode.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 29/09/2023.
//

import Foundation

enum DisplayMode {
    case list
    case grid

    var icon: String {
        switch self {
        case .list:
            return "square.grid.2x2"
        case .grid:
            return "list.dash"
        }
    }
}
