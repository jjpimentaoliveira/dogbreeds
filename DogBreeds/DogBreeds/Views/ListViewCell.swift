//
//  BreedListViewCell.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct ListViewCell: View {
    let breed: DogBreed

    var body: some View {
        HStack {
            MainViewImageView(breed: breed)
            MainViewText(breed: breed)
        }
    }
}

#Preview {
    ListViewCell(breed: DogBreed(id: 1))
}
