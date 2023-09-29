//
//  ListView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 25/09/2023.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var mainViewViewModel: MainViewViewModel
    @ObservedObject var sortOrderViewModel: SortOrderViewModel
    let breeds: [DogBreed]

    var body: some View {
        List(breeds, id: \.id) { breed in
            NavigationLink(destination: DetailsView(breed: breed)) {
                ListViewCell(breed: breed)
                    .task {
                        if mainViewViewModel.shouldLoadNextPage(breed: breed) {
                            await mainViewViewModel.loadNextPage(with: sortOrderViewModel.sortOrder)
                        }
                    }
            }
        }
    }
}

#Preview {
    ListView(
        mainViewViewModel: MainViewViewModel(),
        sortOrderViewModel: SortOrderViewModel(),
        breeds: []
    )
}
