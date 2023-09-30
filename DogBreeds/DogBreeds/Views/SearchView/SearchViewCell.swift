//
//  SearchViewCell.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 30/09/2023.
//

import SwiftUI

struct SearchViewCell: View {
    let breed: DogBreed

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(breed.name)
                .font(.headline)

            if let breedGroup = breed.breedGroup, !breedGroup.isEmpty {
                Text("Breed Group: \(breedGroup)")
                    .font(.subheadline)
            }

            if let origin = breed.origin, !origin.isEmpty {
                Text("Origin: \(origin)")
                    .font(.subheadline)
            }
        }
        .padding(8)
    }
}


#Preview {
    SearchViewCell(breed: DogBreed(
        id: 1,
        breedGroup: "Breed group",
        name: "Test",
        origin: "Origin"
    ))
}
