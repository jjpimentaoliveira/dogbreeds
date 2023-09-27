//
//  GridView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct GridView: View {
    let breeds: [DogBreed]
    private let size: CGFloat = 150

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: size))],
                spacing: 16
            ) {
                ForEach(breeds, id: \.id) { breed in
                    NavigationLink(destination: DetailsView(breed: breed)) {
                        GridViewCell(breed: breed)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    GridView(breeds: [])
}
