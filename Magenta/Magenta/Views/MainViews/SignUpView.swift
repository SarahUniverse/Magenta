//
//  SignUpView.swift
//  Magenta
//
//  Created by Sarah Clark on 10/1/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Magenta")
                    .padding(.top, 30)
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.headline)
                    TextField("Enter username", text: $signUpViewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    Text("Email")
                        .font(.headline)
                    TextField("Enter email", text: $signUpViewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    Text("Password")
                        .font(.headline)
                    SecureField("Enter password", text: $signUpViewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("Confirm Password")
                        .font(.headline)
                    SecureField("Confirm password", text: $signUpViewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()

                Button(action: {
                    if self.signUpViewModel.validateFields() {
                        // Here you would typically call an API or save data locally
                        self.signUpViewModel.isSignUpSuccessful = true
                        self.signUpViewModel.errorMessage = ""
                    }
                }, label: {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding()

                Text(signUpViewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()

                Spacer()
            }
            .alert(isPresented: $signUpViewModel.isSignUpSuccessful) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your account has been created. Please log in."),
                    dismissButton: .default(Text("OK")) {
                        // Optionally, navigate back or reset the form
                    }
                )
            }
            .background {
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.8)
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(SignUpViewModel()) // Provide a preview environment object if needed
}
