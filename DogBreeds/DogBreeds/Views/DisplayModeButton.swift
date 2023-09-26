//
//  DisplayModeButton.swift
//  DogBreeds
//
//  Created by José João Pimenta Oliveira on 26/09/2023.
//

import SwiftUI

enum DisplayMode {
    case list
    case grid

    var icon: String {
        switch self {
        case .list:
            return "square.grid.2x2"
        case .grid:
            return "list.dash"
        }
    }
}

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
                .padding()
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }
}

#Preview {
    DisplayModeButton(currentMode: .constant(.list))
}
