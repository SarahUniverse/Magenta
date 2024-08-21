//
//  Overview.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import SwiftUI

struct Overview: View {
    var body: some View {

        if #available(iOS 18.0, *) {
            TabView {
                Tab("Mood", systemImage: "face.smiling.inverse") {
                    EmptyView()
                }

                Tab("Meditate", systemImage: "figure.mind.and.body") {
                    EmptyView()
                }

                Tab("Exercise", systemImage: "figure.run") {
                    EmptyView()
                }

                Tab("Nutrition", systemImage: "fork.knife") {
                    EmptyView()
                }

                Tab("Cycle", systemImage: "circle.dotted") {
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
        } else {
            // TODO: Remove when iOS 17 is no longer supported.
            TabView {
                Text("Mood")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Mood")
                    }

                Text("Meditate")
                    .tabItem {
                        Image(systemName: "figure.mind.and.body")
                        Text("Meditate")
                    }

                Text("Exercise")
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Exercise")
                    }

                Text("Nutrition")
                    .tabItem {
                        Image(systemName: "fork.knife")
                        Text("Nutrition")
                    }

                Text("Cycle")
                    .tabItem {
                        Image(systemName: "circle.dotted")
                        Text("Cycle")
                    }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

}

#Preview {
    Overview()
}
