//
//  FAQView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            // Search Bar
            Section {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search FAQ", text: $viewModel.searchText)
                }
            }

            // Categories or Filtered Results
            if viewModel.searchText.isEmpty {
                // Show categories when not searching
                ForEach(viewModel.categories) { category in
                    Section(header: Text(category.name)) {
                        ForEach(category.questions) { question in
                            FAQQuestionRow(question: question)
                        }
                    }
                }
            } else {
                // Show search results
                if viewModel.filteredQuestions.isEmpty {
                    Text("No matching questions found")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(viewModel.filteredQuestions) { question in
                        FAQQuestionRow(question: question)
                    }
                }
            }

            // Help Section
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Still need help?")
                        .font(.headline)

                    Button(action: {
                        viewModel.contactSupport()
                    }, label: {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Contact Support")
                        }
                    })

                    Button(action: { viewModel.startLiveChat()
                    }, label: {
                        HStack {
                            Image(systemName: "bubble.left.fill")
                            Text("Start Live Chat")
                        }
                    })
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showingSupportSheet) {
            SupportContactView()
        }
    }
}

// MARK: - Supporting Views
struct FAQQuestionRow: View {
    let question: FAQQuestion
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { withAnimation
                {isExpanded.toggle()}
            }, label: {
                HStack {
                    Text(question.question)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .animation(.easeInOut, value: isExpanded)
                }
            })

            if isExpanded {
                Text(question.answer)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 4)

                if !question.relatedLinks.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Related Links:")
                            .font(.caption)
                            .foregroundColor(.gray)

                        ForEach(question.relatedLinks, id: \.url) { link in
                            Link(destination: link.url) {
                                Text(link.title)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct SupportContactView: View {
    @Environment(\.dismiss) var dismiss
    @State private var subject = ""
    @State private var message = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Subject", text: $subject)
                TextEditor(text: $message)
                    .frame(height: 150)

                Button("Send") {
                    // Implement send logic
                    dismiss()
                }
                .disabled(subject.isEmpty || message.isEmpty)
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}



// MARK: - Models
struct FAQCategory: Identifiable {
    let id = UUID()
    let name: String
    let questions: [FAQQuestion]
}

struct FAQQuestion: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let relatedLinks: [FAQLink]
}

struct FAQLink {
    let title: String
    let url: URL
}

// MARK: - Preview
#Preview {
    NavigationStack {
        FAQView()
    }
}
