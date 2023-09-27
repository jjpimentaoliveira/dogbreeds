//
//  DetailsText.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 27/09/2023.
//

import SwiftUI

struct DetailsTextView: View {
    let title: String
    let value: String?
    var unit: String? = nil

    var body: some View {
        if let value = value, !value.isEmpty {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()

                    if let unit, !unit.isEmpty {
                        Text("\(value) (\(unit))")
                    } else {
                        Text("\(value)")
                    }
                }
                Spacer()
            }.padding(.bottom, 6)
        }
    }
}

#Preview {
    DetailsTextView(title: "Title", value: "Value")
}
