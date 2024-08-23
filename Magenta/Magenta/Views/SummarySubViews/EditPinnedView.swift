//
//  EditPinnedView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/23/24.
//

import SwiftUI

struct EditPinnedView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {

            }
            .navigationTitle("Edit Pinned")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EditPinnedView()
}
