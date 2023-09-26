//
//  ListView.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 25/09/2023.
//

import SwiftUI

struct ListView: View {
    let breeds: [DogBreed]
    var body: some View {
        List(breeds, id: \.id) { breed in
            ListViewCell(breed: breed)
        }
    }
}

#Preview {
    ListView(breeds: [])
}
