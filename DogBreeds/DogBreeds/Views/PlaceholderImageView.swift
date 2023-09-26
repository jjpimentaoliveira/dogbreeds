//
//  PlaceholderImageView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct PlaceholderImageView: View {
    var body: some View {
        Image(systemName: "photo.fill")
            .foregroundStyle(.gray)
    }
}

#Preview {
    PlaceholderImageView()
}
