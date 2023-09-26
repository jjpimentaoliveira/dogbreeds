//
//  MainViewImageView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 27/09/2023.
//

import SwiftUI

private struct ImageSize {
    static let width: CGFloat = 70
    static let height: CGFloat = 70
}

struct MainViewImageView: View {
    let breed: DogBreed
    
    var body: some View {
        if let imageURL = breed.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    PlaceholderImageView()
                @unknown default:
                    PlaceholderImageView()
                }
            }
            .frame(width: ImageSize.width, height: ImageSize.height)
        } else {
            PlaceholderImageView()
                .frame(width: ImageSize.width, height: ImageSize.height)
        }
    }
}

#Preview {
    MainViewImageView(breed: DogBreed(id: 1))
}
