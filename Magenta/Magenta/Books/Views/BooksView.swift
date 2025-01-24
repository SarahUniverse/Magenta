//
//  SelfHelpBooksView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import SwiftUI

struct BooksView: View {
    @StateObject private var booksViewModel: BooksViewModel
    @State private var showingAddBookSheet = false
    @State private var newBookTitle = ""
    @State private var newBookAuthor = ""
    @State private var newBookDescription = ""
    @State private var newBookPublisher = ""

    init(booksViewModel: BooksViewModel = BooksViewModel()) {
        _booksViewModel = StateObject(wrappedValue: booksViewModel)
    }

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .brown, location: 0),
            Gradient.Stop(color: .brown.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .brown.opacity(0.3), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            List {
                if booksViewModel.books.isEmpty {
                    ContentUnavailableView("No Books", systemImage: "book", description: Text("Add some books to your reading list"))
                } else {
                    ForEach(booksViewModel.books) { book in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(book.bookTitle)
                                .font(.headline)
                            Text("by \(book.bookAuthor)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(book.bookDescription)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Books that Help Me")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBookSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $showingAddBookSheet) {
                NavigationStack {
                    Form {
                        Section(header: Text("Book Details")) {
                            TextField("Title", text: $newBookTitle)
                            TextField("Author", text: $newBookAuthor)
                            TextField("Description", text: $newBookDescription)
                            TextField("Publisher", text: $newBookPublisher)
                        }
                    }
                    .navigationTitle("Add New Book")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingAddBookSheet = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                let newBook = BookModel(
                                    id: UUID(),
                                    bookTitle: newBookTitle,
                                    bookAuthor: newBookAuthor,
                                    bookDescription: newBookDescription,
                                    bookPublisher: newBookPublisher
                                )
                                booksViewModel.books.append(newBook)

                                // Reset fields
                                newBookTitle = ""
                                newBookAuthor = ""
                                newBookDescription = ""
                                newBookPublisher = ""

                                showingAddBookSheet = false
                            }
                            .disabled(newBookTitle.isEmpty || newBookAuthor.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let viewModel = BooksViewModel()

    viewModel.books = [
        BookModel(
            id: UUID(),
            bookTitle: "Atomic Habits",
            bookAuthor: "James Clear",
            bookDescription: "An easy and proven way to build good habits and break bad ones. The book offers a proven framework for improving every day.",
            bookPublisher: "Penguin Random House"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Deep Work",
            bookAuthor: "Cal Newport",
            bookDescription: "Rules for focused success in a distracted world. Learn to focus without distraction on cognitively demanding tasks.",
            bookPublisher: "Grand Central Publishing"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Think Again",
            bookAuthor: "Adam Grant",
            bookDescription: "The power of knowing what you don't know. Discover the critical art of rethinking: learning to question your opinions and open other people's minds.",
            bookPublisher: "Viking"
        )
    ]

    return BooksView(booksViewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let viewModel = BooksViewModel()

    viewModel.books = [
        BookModel(
            id: UUID(),
            bookTitle: "Atomic Habits",
            bookAuthor: "James Clear",
            bookDescription: "An easy and proven way to build good habits and break bad ones. The book offers a proven framework for improving every day.",
            bookPublisher: "Penguin Random House"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Deep Work",
            bookAuthor: "Cal Newport",
            bookDescription: "Rules for focused success in a distracted world. Learn to focus without distraction on cognitively demanding tasks.",
            bookPublisher: "Grand Central Publishing"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Think Again",
            bookAuthor: "Adam Grant",
            bookDescription: "The power of knowing what you don't know. Discover the critical art of rethinking: learning to question your opinions and open other people's minds.",
            bookPublisher: "Viking"
        )
    ]

    return BooksView(booksViewModel: viewModel)
        .preferredColorScheme(.dark)
}
