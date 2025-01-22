//
//  FAQViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import CoreData

final class FAQViewModel: ObservableObject {
    @Published var categories: [FAQCategory] = []
    @Published var searchText = ""
    @Published var showingSupportSheet = false

    var filteredQuestions: [FAQQuestion] {
        if searchText.isEmpty {
            return categories.flatMap { $0.questions }
        }
        return categories.flatMap { $0.questions }.filter { question in
            question.question.localizedCaseInsensitiveContains(searchText) ||
            question.answer.localizedCaseInsensitiveContains(searchText)
        }
    }

    init() {
        loadFAQData()
    }

    private func loadFAQData() {
        // Sample FAQ data
        categories = [
            FAQCategory(name: "Getting Started", questions: [
                FAQQuestion(
                    question: "How do I create an account?",
                    answer: "You can create an account by tapping the 'Sign Up' button on the login screen and following the registration process.",
                    relatedLinks: [
                        FAQLink(title: "Registration Guide", url: URL(string: "https://example.com/register")!)
                    ]
                ),
                FAQQuestion(
                    question: "What are the system requirements?",
                    answer: "Our app requires iOS 15.0 or later and is compatible with iPhone and iPad.",
                    relatedLinks: []
                )
            ]),
            FAQCategory(name: "Account & Settings", questions: [
                FAQQuestion(
                    question: "How do I reset my password?",
                    answer: "You can reset your password by tapping 'Forgot Password' on the login screen and following the instructions sent to your email.",
                    relatedLinks: []
                ),
                FAQQuestion(
                    question: "How do I change my notification settings?",
                    answer: "Go to Settings > Notifications to customize your notification preferences.",
                    relatedLinks: []
                )
            ]),
            FAQCategory(name: "Troubleshooting", questions: [
                FAQQuestion(
                    question: "The app is running slowly",
                    answer: "Try clearing the cache in Settings > General > Clear Cache. If the problem persists, try reinstalling the app.",
                    relatedLinks: [
                        FAQLink(title: "Troubleshooting Guide", url: URL(string: "https://example.com/troubleshoot")!)
                    ]
                )
            ])
        ]
    }

    func contactSupport() {
        showingSupportSheet = true
    }

    func startLiveChat() {
        // Implement live chat functionality
    }
}
