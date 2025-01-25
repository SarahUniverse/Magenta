//
//  BookRowView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/25/25.
//

import CoreData
import SwiftUI

struct BookRowView: View {
    @ObservedObject var book: BookEntity
    let viewContext: NSManagedObjectContext

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(book.title ?? "")
                        .font(.headline)
                    Text((book.bookEdition ?? "") + " Edition")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("by \(book.author ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(book.bookDescription ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Image(systemName: currentStatus.systemImage)
                        .foregroundColor(.secondary)

                    Spacer()

                    // Move book between statuses
                    Menu {
                        ForEach(BookStatus.allCases.filter { $0 != currentStatus }) { status in
                            Button(action: {
                                updateBookStatus(to: status)
                            }, label: {
                                Text("Move to \(status.rawValue)")
                                Image(systemName: status.systemImage)
                            })
                        }
                    } label: {
                        HStack {
                            Text("Change Status")
                            Image(systemName: "ellipsis.circle")
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 8)
        } header: {
            HStack {
                Image(systemName: currentStatus.systemImage)
                Text(currentStatus.rawValue)
            }
        }
    }

    private var currentStatus: BookStatus {
        BookStatus(rawValue: book.status ?? "") ?? .wantToRead
    }

    private func updateBookStatus(to newStatus: BookStatus) {
        book.status = newStatus.rawValue

        do {
            try viewContext.save()
        } catch {
            print("Error updating book status: \(error)")
        }
    }
}

// MARK: - Previews
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

    // Create a mock book entity
    let mockBook = BookEntity(context: viewContext)
    mockBook.id = UUID()
    mockBook.title = "Sample Book"
    mockBook.author = "John Doe"
    mockBook.bookDescription = "A sample book description"
    mockBook.bookPublisher = "Sample Publisher"
    mockBook.bookEdition = "1st"
    mockBook.status = BookStatus.wantToRead.rawValue

    do {
        try viewContext.save()
    } catch {
        print("Error saving mock book: \(error)")
    }

    return BookRowView(book: mockBook, viewContext: viewContext)
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

    // Create a mock book entity
    let mockBook = BookEntity(context: viewContext)
    mockBook.id = UUID()
    mockBook.title = "Sample Book"
    mockBook.author = "John Doe"
    mockBook.bookDescription = "A sample book description"
    mockBook.bookPublisher = "Sample Publisher"
    mockBook.bookEdition = "1st"
    mockBook.status = BookStatus.wantToRead.rawValue

    do {
        try viewContext.save()
    } catch {
        print("Error saving mock book: \(error)")
    }

    return BookRowView(book: mockBook, viewContext: viewContext)
        .preferredColorScheme(.dark)
}
