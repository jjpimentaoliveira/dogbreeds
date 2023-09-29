//
//  MainView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct MainView: View {
    @State private var displayMode: DisplayMode = .list
    @ObservedObject var viewModel = DogBreedsViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.fetchState {
                case .loading:
                    ProgressView("Fetching Dog Breeds...")
                case .fetched(let breeds):
                    if breeds.isEmpty {
                        Text("No Dog Breeds Found")
                    } else {
                        switch displayMode {
                        case .list:
                            ListView(breeds: breeds)
                        case .grid:
                            GridView(breeds: breeds)
                        }
                    }
                case .error(let error):
                    Text("Error: \(error.localizedDescription)")
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchDogBreeds(with: sortOrderViewModel.sortOrder)
                }
            }
            .navigationBarTitle("Dog Breeds", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DisplayModeButton(currentMode: $displayMode)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
