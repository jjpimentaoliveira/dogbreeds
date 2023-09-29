//
//  GridView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct GridView: View {
    private let size: CGFloat = 150
    
    @ObservedObject var mainViewViewModel: MainViewViewModel
    @ObservedObject var sortOrderViewModel: SortOrderViewModel
    let breeds: [DogBreed]

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: size))],
                spacing: 16
            ) {
                ForEach(breeds, id: \.id) { breed in
                    NavigationLink(destination: DetailsView(breed: breed)) {
                        GridViewCell(breed: breed)
                            .task {
                                if mainViewViewModel.shouldLoadNextPage(breed: breed) {
                                    await mainViewViewModel.loadNextPage(with: sortOrderViewModel.sortOrder)
                                }
                            }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    GridView(
        mainViewViewModel: MainViewViewModel(),
        sortOrderViewModel: SortOrderViewModel(),
        breeds: []
    )
}
