//
//  DetailsView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 25/09/2023.
//

import SwiftUI

struct DetailsView: View {
    public let breed: DogBreed
    var body: some View {
        Text("Breed Name: \(breed.name ?? "Unknown breed")")
            .navigationBarTitle("Detail", displayMode: .inline)
    }
}

#Preview {
    DetailsView(breed: DogBreed(id: 1))
}
