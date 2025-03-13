//
//  AccountSettingsRowView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct SettingsRowView: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(title)
        }
    }
}

// MARK: Previews
#Preview("Light Mode") {
    SettingsRowView(icon: "doc.text.fill", title: "Privacy Policy", color: .gray)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SettingsRowView(icon: "doc.text.fill", title: "Privacy Policy", color: .gray)
        .preferredColorScheme(.dark)
}
