//
//  BlockedUserRow.swift
//  Magenta
//
//  Created by Sarah Clark on 1/21/25.
//

import SwiftUI

struct BlockedUserRow: View {
    let user: BlockedUserModel
    let unblockAction: () -> Void

    var body: some View {
        HStack {
            if let avatarURL = user.avatarURL {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text("Blocked on \(user.blockedDate.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: unblockAction) {
                Text("Unblock")
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
        }
        .padding(.vertical, 4)
    }
}
