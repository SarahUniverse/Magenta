//
//  NavigationChevron.swift
//  Magenta
//
//  Created by Sarah Clark on 4/9/25.
//

import SwiftUI

struct NavigationChevron: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.blue)
    }

}

#Preview("Light Mode") {
    NavigationChevron()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationChevron()
        .preferredColorScheme(.dark)
}
