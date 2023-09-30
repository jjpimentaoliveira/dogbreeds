//
//  MainViewText.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 27/09/2023.
//

import SwiftUI

struct MainViewText: View {
    let breed: DogBreed
    
    var body: some View {
        Text(breed.name)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .foregroundStyle(.black)
    }
}

#Preview {
    MainViewText(breed: DogBreed(id: 1))
}
