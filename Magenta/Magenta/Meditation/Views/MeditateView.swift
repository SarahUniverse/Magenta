//
//  MeditateView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/21/24.
//

import CoreData
import SwiftUI

struct MeditateView: View {
    @StateObject private var meditateViewModel: MeditateViewModel

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .cyan, location: 0),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(viewContext: NSManagedObjectContext) {
        _meditateViewModel = StateObject(wrappedValue: MeditateViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ForEach(meditateViewModel.meditationSessions, id: \.self) { session in
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.darkBlue)
                                .frame(height: 100)
                                .shadow(radius: 3)
                                .visualEffect { content, proxy in
                                    let frame = proxy.frame(in: .scrollView(axis: .vertical))
                                    _ = proxy
                                        .bounds(of: .scrollView(axis: .vertical)) ??
                                        .infinite

                                    // The distance this view extends past the bottom edge
                                    // of the scroll view.
                                    let distance = min(0, frame.minY)

                                    return content
                                        .hueRotation(.degrees(frame.origin.y / 10))
                                        .scaleEffect(1 + distance / 700)
                                        .offset(y: -distance / 1.25)
                                        .brightness(-distance / 400)
                                        .blur(radius: -distance / 50)
                                }
                            VStack {
                                HStack {
                                    Text(session)
                                        .foregroundStyle(.white)
                                        .bold(true)
                                    Text("blah")
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Meditate")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }
}

#Preview ("Light Mode") {
    MeditateView()
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    MeditateView()
        .preferredColorScheme(.dark)
}
