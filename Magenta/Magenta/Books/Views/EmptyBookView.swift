//
//  EmptyBookView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/25/25.
//

import SwiftUI

struct EmptyBooksView: View {
    let status: BookStatus?
    let action: () -> Void

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(.secondary)

            Text(emptyStateTitle)
                .font(.title2)
                .fontWeight(.semibold)

            Text(emptyStateDescription)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button(action: action) {
                Label("Add Your First Book", systemImage: "plus.circle.fill")
                    .foregroundStyle(.white, .indigo)
                    .shadow(radius: 5, y: 3)
                    .padding()
                    .background(Color.indigo.opacity(0.4))
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary.opacity(0.1))
    }

    // MARK: - Private Variables for View
    private var emptyStateTitle: String {
        switch status {
            case .wantToRead:
                return "No Books to Read Yet"
            case .currentlyReading:
                return "Not Currently Reading Any Books"
            case .finishedReading:
                return "No Finished Books"
            case nil:
                return "Your Bookshelf is Empty"
            }
    }

    private var emptyStateDescription: String {
        switch status {
        case .wantToRead:
            return "Add books you're looking forward to reading."
        case .currentlyReading:
            return "Start a new book and track your reading progress."
        case .finishedReading:
            return "Complete some books to see them here."
        case nil:
            return "Start your reading journey by adding a book to your collection."
        }
    }

}

// MARK: - Previews
#Preview("Want to Read") {
    EmptyBooksView(status: .wantToRead, action: {})
}

#Preview("Currently Reading") {
    EmptyBooksView(status: .currentlyReading, action: {})
}

#Preview("Finished Reading") {
    EmptyBooksView(status: .finishedReading, action: {})
}

#Preview("All Books") {
    EmptyBooksView(status: nil, action: {})
}
