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
        List(viewModel.dogBreeds, id: \.id) { breed in
            Text(breed.name ?? "Unknown breed")
        }
        .onAppear {
            viewModel.fetchDogBreeds()
        }
    }
}

#Preview {
    ContentView()
}
