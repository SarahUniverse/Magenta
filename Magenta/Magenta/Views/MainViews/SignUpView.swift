//
//  SignUpView.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showMainView = false

    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.lightPurple,
            Color.darkPurple,
            Color.darkBlue,
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomLeading
    )

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Magenta")
                    .padding(.top, 30)
                    .foregroundStyle(.white)
                    .font(.largeTitle)

                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.7))
                    TextField("Enter username", text: $signUpViewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)

                    Text("Email")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.7))
                    TextField("Enter email", text: $signUpViewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)

                    Text("Password")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.7))
                    SecureField("Enter password", text: $signUpViewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)

                    Text("Confirm Password")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.7))
                    SecureField("Confirm password", text: $signUpViewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                }
                .padding(20)

                Button(action: {
                    if signUpViewModel.doesUserExist(for: signUpViewModel.username) {
                        signUpViewModel.errorMessage = "User already exists. Please log in or use a different username."
                    } else if signUpViewModel.validateFields() {
                        signUpViewModel.signUp()
                    }
                }, label: {
                    Text("Sign Up")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mediumBlue)
                        .cornerRadius(10)
                })
                .padding(20)

                Text(signUpViewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
                Spacer()

                CopyrightView()
                Spacer()
            }
            .onAppear {
                signUpViewModel.setModelContext(modelContext)
            }
            .alert(isPresented: $signUpViewModel.isSignUpSuccessful) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your account has been created."),
                    dismissButton: .default(Text("OK")) {
                        showMainView = true
                    }
                )
            }
            .background(
                NavigationLink(destination: MainView(user: UserModel(id: UUID().uuidString, name: signUpViewModel.username)), isActive: $showMainView) {
                    EmptyView()
                }
                .hidden()
            )
            .onAppear {
                signUpViewModel.setModelContext(modelContext)
            }
            .background(backgroundGradient)
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(SignUpViewModel()) // Provide a preview environment object if needed
}
