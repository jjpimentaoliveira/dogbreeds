//
//  MainView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var displayMode: DisplayMode = .list
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var sortOrderViewModel: SortOrderViewModel

    var body: some View {
        NavigationView {
            ZStack {
                switch mainViewModel.fetchState {
                case .loading:
                    ProgressView("Fetching Dog Breeds...")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                case .fetched(let breeds):
                    if breeds.isEmpty {
                        Text("No Dog Breeds Found")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    } else {
                        switch displayMode {
                        case .list:
                            ListView(
                                mainViewModel: mainViewModel,
                                sortOrderViewModel: sortOrderViewModel,
                                breeds: breeds
                            )
                        case .grid:
                            GridView(
                                mainViewModel: mainViewModel,
                                sortOrderViewModel: sortOrderViewModel,
                                breeds: breeds
                            )
                        }
                    }
                case .error(let error):
                    Text("Error: \(error.localizedDescription)")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
            }
            .onAppear {
                Task {
                    if mainViewModel.sortedBreeds.isEmpty {
                        await mainViewModel.fetchInitialDogBreeds(with: sortOrderViewModel.sortOrder)
                    }
                }
            }
            .navigationBarTitle("Dog Breeds", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DisplayModeButton(currentMode: $displayMode)
                }

                ToolbarItem(placement: .topBarLeading) {
                    SortOrderButton(
                        mainViewModel: mainViewModel,
                        sortOrderViewModel: sortOrderViewModel
                    )
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    MainView()
}
