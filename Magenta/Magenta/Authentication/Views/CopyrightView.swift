//
//  CopyrightView.swift
//  Magenta
//
//  Created by Sarah Clark on 12/9/24.
//

import SwiftUI

struct CopyrightView: View {
    var body: some View {
        Text("© \(String(Calendar.current.component(.year, from: Date()))) SarahUniverse")
            .font(.caption)
            .bold()
            .foregroundStyle(.white.opacity(0.8))
    }
}
