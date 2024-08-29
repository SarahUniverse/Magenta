//
//  LoginView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var items: [Item]
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var userInfo = ""
    @State private var isNavigating = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Magenta")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()

                TextField("Username", text: $username)
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
                    loginUser()
                    isNavigating = true
                }, label: {
                    Text("Login")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding()

                .navigationDestination(isPresented: $isNavigating) {
                    MainView(user: User(id: "", name: "", isLoggedIn: true))
                }

                Text("Or sign in with")
                    .foregroundStyle(.white)
                    .bold()

                CustomGoogleSignInButton(action: {
                    self.signInWithGoogle()
                })
                .frame(height: 40)
                .padding()

                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success:
                        isNavigating = true
                        print("Authorization successful")
                    case .failure(let error):
                        print("Authorization failed: \(error.localizedDescription)")
                    }
                }
                .frame(height: 40)
                .padding()
                .signInWithAppleButtonStyle(colorScheme == .light ? .white : .black)
            }
            .background {
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.8)
            }
        }
    }

    func loginUser() {
        let newUser = User(id: UUID().uuidString, name: username, isLoggedIn: true)
        modelContext.insert(newUser)
    }

    func signInWithGoogle() {
        guard let rootViewController = self.rootViewController else {
            print("Root view controller not found")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard let result else {
                print("Error signing in: \(String(describing: error))")
                return
            }
            print("Successfully signed in user")
            self.userInfo = result.user.profile?.json ?? ""
            isNavigating = true
        }
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

private extension LoginView {
    var rootViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.keyWindow }
            .first?.rootViewController
    }
}

private extension GIDProfileData {
    var json: String {
    """
    success: {
      Given Name: \(self.givenName ?? "None")
      Family Name: \(self.familyName ?? "None")
      Name: \(self.name)
      Email: \(self.email)
      Profile Photo: \(self.imageURL(withDimension: 1)?.absoluteString ?? "None");
    }
    """
    }
}

#Preview {
    LoginView()
        .modelContainer(for: Item.self, inMemory: true)
}
