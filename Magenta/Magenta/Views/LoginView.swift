//
//  LoginView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import AuthenticationServices
import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var items: [Item]
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Welcome to Magenta")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            Button(action: {
                print("Login button tapped")
            }) {
                Text("Login")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Text("Or sign in with")
                .foregroundStyle(.secondary)

                Button(action: {
                    print("Google Sign-In tapped")
                }) {
                    Image(systemName: "g.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.red)
                }

            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                    case .success(_):
                        print("Authorization successful")
                    case .failure(let error):
                        print("Authorization failed: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(colorScheme == .light ? .white : .black)
        }

        .padding()
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    LoginView()
        .modelContainer(for: Item.self, inMemory: true)
}
