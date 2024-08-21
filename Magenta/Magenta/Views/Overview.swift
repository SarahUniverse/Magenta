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

                Tab("Mood", systemImage: "face.smiling.inverse") {
                    EmptyView()
                }

                Tab("Mood", systemImage: "face.smiling.inverse") {
                    EmptyView()
                }

            }
        } else {
            // TODO: Remove when iOS 17 is no longer supported.
            TabView {
                Text("Home Tab Content")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                Text("Favorites Tab Content")
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }

                Text("Settings Tab Content")
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
            //.navigationTitle("Overview")
            //.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Overview()
}
