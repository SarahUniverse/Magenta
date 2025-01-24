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
    @State private var newBookEdition = ""

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

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            booksList
                .navigationTitle("Books that Help Me")
                .background(backgroundGradient)
                .scrollContentBackground(.hidden)
                .toolbar { toolbarContent }
                .sheet(isPresented: $showingAddBookSheet) { addBookSheet }
        }
    }

    // MARK: - Private Variables for View
    private var booksList: some View {
        List {
            if booksViewModel.books.isEmpty {
                emptyStateView
            } else {
                booksContent
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Books",
            systemImage: "book",
            description: Text("Add some books to your reading list")
        )
    }

    private var booksContent: some View {
        ForEach(booksViewModel.books) { book in
            bookRow(for: book)
        }
    }

    private func bookRow(for book: BookModel) -> some View {
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

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddBookSheet = true
            }, label: {
                Image(systemName: "plus")
            })
        }
    }

    private var addBookSheet: some View {
        NavigationStack {
            addBookForm
                .navigationTitle("Add New Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { addBookToolbar }
        }
        .presentationDetents([.medium])
    }

    private var addBookForm: some View {
        Form {
            Section(header: Text("Book Details")) {
                TextField("Title", text: $newBookTitle)
                TextField("Author", text: $newBookAuthor)
                TextField("Description", text: $newBookDescription)
                TextField("Publisher", text: $newBookPublisher)
            }
        }
    }

    private var addBookToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    showingAddBookSheet = false
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveNewBook()
                }
                .disabled(newBookTitle.isEmpty || newBookAuthor.isEmpty)
            }
        }
    }

    // MARK: - Private Functions
    private func saveNewBook() {
        let newBook = BookModel(
            id: UUID(),
            bookTitle: newBookTitle,
            bookAuthor: newBookAuthor,
            bookDescription: newBookDescription,
            bookPublisher: newBookPublisher,
            bookEdition: newBookEdition
        )
        booksViewModel.books.append(newBook)
        resetFields()
        showingAddBookSheet = false
    }

    private func resetFields() {
        newBookTitle = ""
        newBookAuthor = ""
        newBookDescription = ""
        newBookPublisher = ""
        newBookEdition = ""
    }
}

// MARK: - Previews
// swiftlint:disable line_length
#Preview("Light Mode") {
    let viewModel = BooksViewModel()

    viewModel.books = [
        BookModel(
            id: UUID(),
            bookTitle: "Atomic Habits",
            bookAuthor: "James Clear",
            bookDescription: "An easy and proven way to build good habits and break bad ones. The book offers a proven framework for improving every day.",
            bookPublisher: "Penguin Random House",
            bookEdition: "2nd"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Deep Work",
            bookAuthor: "Cal Newport",
            bookDescription: "Rules for focused success in a distracted world. Learn to focus without distraction on cognitively demanding tasks.",
            bookPublisher: "Grand Central Publishing",
            bookEdition: "2nd Edition"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Think Again",
            bookAuthor: "Adam Grant",
            bookDescription: "The power of knowing what you don't know. Discover the critical art of rethinking: learning to question your opinions and open other people's minds.",
            bookPublisher: "Viking",
            bookEdition: "2nd Edition"
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
            bookPublisher: "Penguin Random House",
            bookEdition: "2nd Edition"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Deep Work",
            bookAuthor: "Cal Newport",
            bookDescription: "Rules for focused success in a distracted world. Learn to focus without distraction on cognitively demanding tasks.",
            bookPublisher: "Grand Central Publishing",
            bookEdition: "2nd Edition"
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Think Again",
            bookAuthor: "Adam Grant",
            bookDescription: "The power of knowing what you don't know. Discover the critical art of rethinking: learning to question your opinions and open other people's minds.",
            bookPublisher: "Viking",
            bookEdition: "2nd Edition"
        )
    ]

    return BooksView(booksViewModel: viewModel)
        .preferredColorScheme(.dark)
}
// swiftlint:enable line_length
