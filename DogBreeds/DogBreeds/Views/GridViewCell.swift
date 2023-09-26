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
            AsyncImage(url: breed.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: ImageSize.width, height: ImageSize.height)
                case .failure:
                    Image(systemName: "photo.fill")
                        .frame(width: ImageSize.width, height: ImageSize.height)
                @unknown default:
                    Image(systemName: "photo.fill")
                        .frame(width: ImageSize.width, height: ImageSize.height)
                }
            }
            .frame(width: ImageSize.width, height: ImageSize.height)

            Text(breed.name ?? "Unknown Breed")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    GridViewCell(breed: DogBreed(id: 1))
}
