//
//  SortOrderButton.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 29/09/2023.
//

import SwiftUI

struct SortOrderButton: View {
    @ObservedObject var sortOrderViewModel: SortOrderViewModel
    @ObservedObject var viewModel: DogBreedsViewModel

    var body: some View {
        Button(action: {
            switch sortOrderViewModel.sortOrder {
            case .ascending:
                sortOrderViewModel.sortOrder = .descending
            case .descending:
                sortOrderViewModel.sortOrder = .ascending
            }

            Task {
                await viewModel.clearAndFetchBreeds(with: sortOrderViewModel.sortOrder)
            }
        }) {
            Image(systemName: sortOrderViewModel.sortOrder.icon)
                .foregroundColor(.black)
                .padding()
        }
    }
}

#Preview {
    SortOrderButton(
        sortOrderViewModel: SortOrderViewModel(),
        viewModel: DogBreedsViewModel()
    )
}
