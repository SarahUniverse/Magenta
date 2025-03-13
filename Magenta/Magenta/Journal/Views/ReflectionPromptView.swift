//
//  ReflectionPromptView.swift
//  Magenta
//
//  Created by Sarah Clark on 1/19/25.
//

#if canImport(JournalingSuggestions)
import JournalingSuggestions
import SwiftUI

struct ReflectionPromptView: View {
    @Binding var suggestion: JournalingSuggestion.Reflection

    var body: some View {
        let reflectionSuggestion = $suggestion.wrappedValue
        let backgroundColor = reflectionSuggestion.color ?? .white

        Text(reflectionSuggestion.prompt)
            .font(.title)
            .bold()
            .multilineTextAlignment(.center)
            .foregroundStyle(foregroundStyle(for: backgroundColor))
            .frame(maxHeight: .infinity)
            .padding()
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 16))
            .padding()
    }

    private func foregroundStyle(for backgroundColor: Color) -> Color {
        var whiteValue = CGFloat()
        if UIColor(backgroundColor).getWhite(&whiteValue, alpha: nil) {
            return whiteValue > 0.6 ? .black : .white
        }
        return .white
    }
}
#endif
