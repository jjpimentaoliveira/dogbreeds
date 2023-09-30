//
//  SearchView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 25/09/2023.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @ObservedObject private var searchViewModel = SearchViewModel()
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter breed name", text: $searchQuery)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: searchQuery, initial: true) { _, newValue in
                        searchViewModel.filterBreeds(by: newValue, in: mainViewModel.sortedBreeds)
                    }

                List(searchViewModel.filteredBreeds, id: \.id) { breed in
                    NavigationLink(destination: DetailsView(breed: breed)) {
                        SearchViewCell(breed: breed)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("Search Breeds", displayMode: .inline)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    SearchView()
}
