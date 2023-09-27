//
//  GridListViewCell.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct GridViewCell: View {
    let breed: DogBreed

    var body: some View {
        VStack {
            MainViewImageView(breed: breed)
            MainViewText(breed: breed)
        }
    }
}

#Preview {
    GridViewCell(breed: DogBreed(id: 1))
}
