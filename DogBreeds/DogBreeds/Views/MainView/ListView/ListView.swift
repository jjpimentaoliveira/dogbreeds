//
//  ListView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 25/09/2023.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var sortOrderViewModel: SortOrderViewModel
    let breeds: [DogBreed]

    var body: some View {
        List(breeds, id: \.id) { breed in
            NavigationLink(destination: DetailsView(breed: breed)) {
                ListViewCell(breed: breed)
                    .task {
                        if mainViewModel.shouldLoadNextPage(breed: breed) {
                            await mainViewModel.loadNextPage(with: sortOrderViewModel.sortOrder)
                        }
                    }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ListView(
        mainViewModel: MainViewModel(),
        sortOrderViewModel: SortOrderViewModel(),
        breeds: []
    )
}
