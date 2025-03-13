//
//  SearchView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/14/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var text: String
    @Binding var isListening: Bool
    var startListening: () -> Void
    var stopListening: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)

            TextField("Search", text: $text)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                })
            }

            Divider()
                .frame(height: 20)

            Button(action: {
                isListening.toggle()
                if isListening {
                    startListening()
                } else {
                    stopListening()
                }
            }, label: {
                Image(systemName: isListening ? "mic.slash.fill" : "mic.fill")
                    .foregroundStyle(isListening ? .red : .gray)
            })
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    SearchView(
        text: .constant("Search"),
        isListening: .constant(false),
        startListening: {},
        stopListening: {}
    )
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SearchView(
        text: .constant("Search"),
        isListening: .constant(false),
        startListening: {},
        stopListening: {}
    )
        .preferredColorScheme(.dark)
}
