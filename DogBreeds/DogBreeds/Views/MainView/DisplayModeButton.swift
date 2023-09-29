//
//  DisplayModeButton.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

struct DisplayModeButton: View {
    @Binding var currentMode: DisplayMode

    var body: some View {
        Button(action: {
            switch currentMode {
            case .list:
                currentMode = .grid
            case .grid:
                currentMode = .list
            }
        }) {
            Image(systemName: currentMode.icon)
                .foregroundColor(.black)
                .padding()
        }
    }
}

#Preview {
    DisplayModeButton(currentMode: .constant(.list))
}
