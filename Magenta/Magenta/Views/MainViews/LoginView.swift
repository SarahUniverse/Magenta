//
//  LoginView.swift
//  Magenta
//
//  Created by Sarah Clark on 8/6/24.
//

import SwiftData
import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel: LoginViewModel

    init(modelContext: ModelContext) {
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Magenta")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()

                TextField("Username", text: $loginViewModel.username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $loginViewModel.password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    loginViewModel.checkPassword()
                    if loginViewModel.isLoggedIn {
                        loginViewModel.isNavigating = true
                    }
                }, label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding()

                Text(loginViewModel.error)
                    .foregroundColor(.red)
                    .navigationDestination(isPresented: $loginViewModel.isNavigating) {
                        MainView(user: UserModel(id: "", name: ""))
                    }

                Text("Or sign in with")
                    .foregroundColor(.white)
                    .bold()

                CustomGoogleSignInButton(action: loginViewModel.signInWithGoogle)
                    .frame(height: 40)
                    .padding()

                loginViewModel.setupAppleSignInButton()
                    .frame(height: 40)
                    .padding()
                    .signInWithAppleButtonStyle(.white)
            }
            .background(
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.8)
            )
        }
    }
}

#Preview {
    do {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DummyItem.self, configurations: configuration)
        let context = container.mainContext

        return LoginView(modelContext: context)
    } catch {
        print("Failed to create ModelContainer for preview: \(error)")
        return Text("Preview Setup Failed")
    }
}
