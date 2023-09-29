//
//  SortOrderViewModel.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 29/09/2023.
//

import Foundation

public class SortOrderViewModel: ObservableObject {
    @Published var sortOrder: SortOrder = .ascending
}
