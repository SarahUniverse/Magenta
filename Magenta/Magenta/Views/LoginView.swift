//
//  LoginView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
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

            HStack (spacing: 20) {
                Button(action: {
                    print("Google Sign-In tapped")
                }) {
                    Image(systemName: "g.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.red)
                }

                Button(action: {
                    print("Apple Sign-In tapped")
                }) {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.black)
                }
            }
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
