//
//  ContentView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "rectangle.and.text.magnifyingglass")
                }
        }
    }
}

#Preview {
    ContentView()
}
