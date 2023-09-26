//
//  GridListViewCell.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

private struct ImageSize {
    static let width: CGFloat = 70
    static let height: CGFloat = 70
}

struct GridViewCell: View {
    let breed: DogBreed

    var body: some View {
        VStack {
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

            Text(breed.name ?? "Unknown Breed")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    GridViewCell(breed: DogBreed(id: 1))
}
