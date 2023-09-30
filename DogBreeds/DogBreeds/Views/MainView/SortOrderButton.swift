//
//  SortOrderButton.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 29/09/2023.
//

import SwiftUI

struct SortOrderButton: View {
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var sortOrderViewModel: SortOrderViewModel

    var body: some View {
        Button(action: {
            switch sortOrderViewModel.sortOrder {
            case .ascending:
                sortOrderViewModel.sortOrder = .descending
            case .descending:
                sortOrderViewModel.sortOrder = .ascending
            }
            Task {
                await mainViewModel.clearAndFetchBreeds(with: sortOrderViewModel.sortOrder)
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
        mainViewModel: MainViewModel(), 
        sortOrderViewModel: SortOrderViewModel()
    )
}
