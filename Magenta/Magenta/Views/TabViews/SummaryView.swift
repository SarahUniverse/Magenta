//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SummaryView: View {

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notifications")) {

                }

                Section {
                    Text("Blah blah blah")
                } header: {
                    HStack {
                        Text("Pinned")
                        Spacer()
                        NavigationLink(destination: EditPinnedView()) {
                            Text("Edit")
                        }
                    }
                }
            }

            .navigationTitle("Summary")
            .toolbarBackground(.purpleBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }
}

#Preview {
    SummaryView()
}
