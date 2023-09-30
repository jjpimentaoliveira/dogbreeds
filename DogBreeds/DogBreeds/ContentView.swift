//
//  ContentView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mainViewModel = MainViewModel()

    var body: some View {
        TabView {
            MainView()
                .environmentObject(mainViewModel)
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }

            SearchView()
                .environmentObject(mainViewModel)
                .tabItem {
                    Label("Search", systemImage: "rectangle.and.text.magnifyingglass")
                }
        }
    }
}

#Preview {
    ContentView()
}
