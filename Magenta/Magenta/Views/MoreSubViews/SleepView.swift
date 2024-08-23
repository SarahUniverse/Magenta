//
//  SleepView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SleepView: View {

    var body: some View {
        NavigationStack {
            List {
                Text("Hello, World!")
            }
            .navigationTitle("Mood")
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
    SleepView()
}
