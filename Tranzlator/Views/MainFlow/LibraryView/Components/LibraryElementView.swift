//
//  LibraryElementView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 712..2021.
//

import SwiftUI

struct LibraryElementView: View {
    var translation: TranslationModelDB
    var languageNameParcer: (String) -> String
    var body: some View {
        VStack {
            HStack {
                Text("Translated from \(languageNameParcer(translation.sourceLangCode).capitalized) to \(translation.targetLangName.capitalized)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            HStack(alignment: .top) {
                HStack {
                    Text(translation.originalText)
                        .lineLimit(2)
                    Spacer()
                }
                Spacer().frame(width: 8)
                HStack {
                    Spacer()
                    Text(translation.translatedText)
//                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                }
            }
        }
        
    }
}

struct LibraryElementView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryElementView(
            translation: TranslationModelDB(
                "txttxt txttxt txttxt txttxtxtt txttxttxt txttxt txt",
                fromText: "text",
                fromLanguage: "en",
                toLanguageNamed: "russian",
                toLanguagedCoded: "ru"
            ),
            languageNameParcer: { code in
                code
            }
        )
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
