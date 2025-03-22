//
//  EditProfileView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = EditProfileViewModel()
    @State private var showImagePicker = false

    var body: some View {
        List {
            Section {
                HStack {
                    if let image = viewModel.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.gray)
                    }

                    Button("Change Photo") {
                        showImagePicker = true
                    }
                }
                .padding(.vertical, 8)
            }

            Section("Personal Information") {
                TextField("First Name", text: $viewModel.firstName)
                TextField("Last Name", text: $viewModel.lastName)
                TextField("Display Name", text: $viewModel.displayName)
                DatePicker("Birthday", selection: $viewModel.birthday, displayedComponents: .date)
            }

            Section("Contact Information") {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Phone", text: $viewModel.phone)
                    .keyboardType(.phonePad)
            }

            Section("Bio") {
                TextEditor(text: $viewModel.bio)
                    .frame(height: 100)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveProfile()
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.profileImage)
        }
    }
}
