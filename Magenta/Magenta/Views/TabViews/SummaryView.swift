//
//  SummaryView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct SummaryView: View {
    @State private var showingModal = false

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
            Color.darkPurple,
            Color.darkBlue,
            Color.black,
            Color.black,
            Color.black,
            Color.black,
            Color.black

        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                    .frame(height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Section(header: Text("Notifications")) {

                     }
                    .background(.almostBlack)
                    .padding()
                     Section {
                         Text("Blah blah blah")
                         } header: {

                         HStack {
                             Text("Pinned")
                             Spacer()

                             Button("Edit") {
                             showingModal.toggle()
                             }
                         }
                    }
                    .background(.almostBlack)
                }
                .navigationBarTitle("Summary")
                .foregroundStyle(Color.white)
            }


        }
    }
}

#Preview {
    SummaryView()
}
