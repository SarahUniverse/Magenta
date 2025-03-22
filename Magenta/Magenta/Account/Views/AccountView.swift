//
//  AccountView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/22/24.
//

import CoreData
import SwiftUI

struct AccountView: View {
    @State private var accountViewModel: AccountViewModel
    @Environment(\.colorScheme) private var colorScheme

    init(viewContext: NSManagedObjectContext, colorScheme: ColorScheme) {
        _accountViewModel = State(wrappedValue: AccountViewModel(viewContext: viewContext, colorScheme: colorScheme))
    }

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .darkPurple.opacity(0.5), location: 0),
            Gradient.Stop(color: .darkPurple.opacity(0.7), location: 0.1),
            Gradient.Stop(color: .darkBlue.opacity(0.7), location: 0.2),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.gray)

                        VStack(alignment: .leading) {
                            Text(accountViewModel.userName)
                                .font(.headline)
                            Text(accountViewModel.userEmail)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Account Settings") {
                    NavigationLink(destination: EditProfileView()) {
                        SettingsRowView(icon: "person.fill",
                                        title: "Edit Profile",
                                        color: .blue)
                    }

                    NavigationLink(destination: NotificationSettingsView()) {
                        SettingsRowView(icon: "bell.fill",
                                        title: "Notifications",
                                        color: .red)
                    }

                    NavigationLink(destination: PrivacySettingsView()) {
                        SettingsRowView(icon: "lock.fill",
                                        title: "Privacy",
                                        color: .green)
                    }
                }

                Section("Preferences") {
                    Toggle("Dark Mode", isOn: $accountViewModel.isDarkMode)

                    Picker("Language", selection: $accountViewModel.selectedLanguage) {
                        ForEach(accountViewModel.availableLanguages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                }

                Section("Support") {
                    Button(action: { accountViewModel.contactSupport()
                    }, label: {
                        SettingsRowView(icon: "questionmark.circle.fill",
                                        title: "Help & Support",
                                        color: .purple)
                    })

                    NavigationLink(destination: FAQView()) {
                        SettingsRowView(icon: "doc.text.fill",
                                        title: "FAQ",
                                        color: .orange)
                    }
                }

                Section("Legal") {
                    Button(action: { accountViewModel.showPrivacyPolicy()
                    }, label: {
                        SettingsRowView(icon: "doc.fill",
                                        title: "Privacy Policy",
                                        color: .gray)
                    })

                    Button(action: { accountViewModel.showTerms()
                    }, label: {
                        SettingsRowView(icon: "doc.text.fill",
                                        title: "Terms of Service",
                                        color: .gray)
                    })
                }

                Section {
                    Button(action: { accountViewModel.deleteAccount()
                    }, label: {
                        HStack {
                            Text("Delete Account")
                            Spacer()
                            Image(systemName: "trash.fill")
                        }
                        .foregroundStyle(.red)
                    })
                }
            }
            .padding(.top, 20)
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .fullScreenCover(isPresented: $accountViewModel.shouldShowLoginView) {
                LoginView(viewContext: accountViewModel.viewContext)
            }
            .alert("Delete Account", isPresented: $accountViewModel.showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    accountViewModel.confirmDeleteAccount()
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
            .navigationTitle("Account")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        accountViewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                            .padding(8)
                    })
            )
            .onChange(of: colorScheme) {
                accountViewModel.updateColorScheme($1)
            }
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

    return AccountView(viewContext: persistentContainer.viewContext, colorScheme: .light)
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

    return AccountView(viewContext: persistentContainer.viewContext, colorScheme: .dark)
        .preferredColorScheme(.dark)
}
