//
//  BooksView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct BooksView: View {
    @State private var booksViewModel: BooksViewModel
    @State private var selectedStatus: BookStatus?
    @State private var showingAddBookSheet = false
    @State private var newBookTitle = ""
    @State private var newBookAuthor = ""
    @State private var newBookDescription = ""
    @State private var newBookPublisher = ""
    @State private var newBookEdition = ""
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _booksViewModel = State(wrappedValue: BooksViewModel(viewContext: viewContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if !booksViewModel.books.isEmpty {
                    statusPicker
                }
                booksList
            }
            .navigationTitle("Books that Help Me")
            .background(AppGradients.backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                if !booksViewModel.books.isEmpty {
                    toolbarContent
                }
            }
            .sheet(isPresented: $showingAddBookSheet) { addBookSheet }
        }
    }

    // MARK: - Private Variables for View
    private var statusPicker: some View {
        Picker("Reading Status", selection: $selectedStatus) {
            ForEach(BookStatus.allCases) { status in
                HStack(spacing: 0) {
                    Text(status.rawValue)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .tag(status as BookStatus?)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .foregroundStyle(.secondary)
    }

    private var booksList: some View {
        Group {
            if filteredBooks.isEmpty {
                EmptyBooksView(
                    status: selectedStatus,
                    action: { showingAddBookSheet = true }
                )
            } else {
                Form {
                    ForEach(filteredBooks) { book in
                        BookRowView(book: book, viewContext: viewContext)
                    }
                    .onDelete(perform: deleteBooks)
                }
            }
        }
        .listStyle(PlainListStyle())
    }

    private var filteredBooks: [BookModel] {
        selectedStatus == nil
        ? booksViewModel.books
        : booksViewModel.books.filter { $0.status == selectedStatus }
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddBookSheet = true
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.white, .blue)
                    .shadow(radius: 5, y: 3)
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
                TextField("Edition", text: $newBookEdition)

                Picker(selectedStatus == nil ? "Select Status" : "Reading Status", selection: $selectedStatus) {
                    ForEach(BookStatus.allCases) { status in
                        Text(status.rawValue)
                            .tag(status as BookStatus?)
                    }
                }
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
                .disabled(
                    newBookTitle.isEmpty ||
                    newBookAuthor.isEmpty ||
                    newBookDescription.isEmpty ||
                    newBookPublisher.isEmpty ||
                    newBookEdition.isEmpty ||
                    selectedStatus == nil
                )
            }
        }
    }

    // MARK: - Private Functions
    private func saveNewBook() {
        guard let status = selectedStatus else {
            // Handle case where no status is selected
            return
        }

        let newBook = BookModel(
            id: UUID(),
            bookTitle: newBookTitle,
            bookAuthor: newBookAuthor,
            bookDescription: newBookDescription,
            bookPublisher: newBookPublisher,
            bookEdition: newBookEdition,
            status: status
        )

        booksViewModel.addBook(newBook)

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

    private func deleteBooks(at offsets: IndexSet) {
        offsets.forEach { index in
            let bookToDelete = filteredBooks[index]
            booksViewModel.removeBook(bookToDelete)
        }
    }

}

// MARK: - Previews
// swiftlint:disable line_length
#Preview("Light Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    let viewContext = persistentContainer.viewContext
    let booksViewModel = BooksViewModel(viewContext: viewContext)

    let sampleBooks = [
        BookModel(
            id: UUID(),
            bookTitle: "Atomic Habits",
            bookAuthor: "James Clear",
            bookDescription: "An easy and proven way to build good habits and break bad ones. The book offers a proven framework for improving every day.",
            bookPublisher: "Penguin Random House",
            bookEdition: "2nd",
            status: .wantToRead
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Deep Work",
            bookAuthor: "Cal Newport",
            bookDescription: "Rules for focused success in a distracted world. Learn to focus without distraction on cognitively demanding tasks.",
            bookPublisher: "Grand Central Publishing",
            bookEdition: "3rd",
            status: .currentlyReading
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Think Again",
            bookAuthor: "Adam Grant",
            bookDescription: "The power of knowing what you don't know. Discover the critical art of rethinking: learning to question your opinions and open other people's minds.",
            bookPublisher: "Viking",
            bookEdition: "1st",
            status: .finishedReading
        )
    ]

    // Add sample books to CoreData
    sampleBooks.forEach { book in
        let bookEntity = BookEntity(context: viewContext)
        bookEntity.id = book.id
        bookEntity.title = book.bookTitle
        bookEntity.author = book.bookAuthor
        bookEntity.bookDescription = book.bookDescription
        bookEntity.bookPublisher = book.bookPublisher
        bookEntity.bookEdition = book.bookEdition
        bookEntity.status = book.status.rawValue
    }

    do {
        try viewContext.save()
    } catch {
        print("Error saving sample books: \(error)")
    }

    return BooksView(viewContext: viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    let viewContext = persistentContainer.viewContext
    let booksViewModel = BooksViewModel(viewContext: viewContext)

    let sampleBooks = [
        BookModel(
            id: UUID(),
            bookTitle: "Atomic Habits",
            bookAuthor: "James Clear",
            bookDescription: "An easy and proven way to build good habits and break bad ones. The book offers a proven framework for improving every day.",
            bookPublisher: "Penguin Random House",
            bookEdition: "2nd",
            status: .wantToRead
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Deep Work",
            bookAuthor: "Cal Newport",
            bookDescription: "Rules for focused success in a distracted world. Learn to focus without distraction on cognitively demanding tasks.",
            bookPublisher: "Grand Central Publishing",
            bookEdition: "3rd",
            status: .currentlyReading
        ),
        BookModel(
            id: UUID(),
            bookTitle: "Think Again",
            bookAuthor: "Adam Grant",
            bookDescription: "The power of knowing what you don't know. Discover the critical art of rethinking: learning to question your opinions and open other people's minds.",
            bookPublisher: "Viking",
            bookEdition: "1st",
            status: .finishedReading
        )
    ]

    // Add sample books to CoreData
    sampleBooks.forEach { book in
        let bookEntity = BookEntity(context: viewContext)
        bookEntity.id = book.id
        bookEntity.title = book.bookTitle
        bookEntity.author = book.bookAuthor
        bookEntity.bookDescription = book.bookDescription
        bookEntity.bookPublisher = book.bookPublisher
        bookEntity.bookEdition = book.bookEdition
        bookEntity.status = book.status.rawValue
    }

    do {
        try viewContext.save()
    } catch {
        print("Error saving sample books: \(error)")
    }

    return BooksView(viewContext: viewContext)
        .preferredColorScheme(.dark)
}
// swiftlint:enable line_length
