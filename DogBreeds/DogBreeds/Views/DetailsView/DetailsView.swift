//
//  DetailsView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 27/09/2023.
//

import SwiftUI

struct DetailsView: View {
    private let padding: CGFloat = 6.0
    let breed: DogBreed

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        DetailsTextView(title: "Temperament:", value: breed.temperament)
                        DetailsTextView(title: "Height:", value: breed.height?.metric, unit: "kg")
                        DetailsTextView(title: "Weight:", value: breed.weight?.metric, unit: "cm")
                        DetailsTextView(title: "Origin:", value: breed.origin)
                        DetailsTextView(title: "Bred For:", value: breed.bredFor)
                        DetailsTextView(title: "Breed Group:", value: breed.breedGroup)
                        DetailsTextView(title: "Life Span:", value: breed.lifeSpan)
                        DetailsTextView(title: "Country Code:", value: breed.countryCode)
                        DetailsTextView(title: "History:", value: breed.history)
                        DetailsTextView(title: "Description:", value: breed.description)
                    }
                    .frame(width: geometry.size.width - padding)
                }
                .scrollIndicators(.never)
                .padding(padding)
            }
            .navigationBarTitle(breed.name ?? "Unknown breed", displayMode: .inline)
        }
    }
}

#Preview {
    DetailsView(breed: DogBreed(id: 1))
}
