//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SummaryView: View {
    @State private var showingModal = false

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
                        Button("Edit") {
                            showingModal.toggle()
                        }
                        .sheet(isPresented: $showingModal) {
                            EditPinnedView()
                        }
                    }
                }
            }

            .navigationTitle("Summary")
            .toolbarBackground(.purple2, for: .navigationBar)
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
