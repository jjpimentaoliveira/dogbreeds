//
//  ContentView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 24/09/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = DogBreedsViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.fetchState {
            case .loading:
                ProgressView("Fetching Dog Breeds...")
            case .fetched(let breeds):
                if breeds.isEmpty {
                    Text("No Dog Breeds Found")
                } else {
                    List(breeds, id: \.id) { breed in
                        Text(breed.name ?? "Unknown breed")
                    }
                }
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchDogBreeds()
            }
        }
    }
}

#Preview {
    ContentView()
}
