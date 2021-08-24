//
//  SupportedLanguagesView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 79..2021.
//

import SwiftUI

struct SupportedLanguagesView: View {
    @EnvironmentObject var api: API
    @Binding var isPresent: Bool
    @Binding var target: Language
    @Binding var shouldPerformRequest: Bool
    var body: some View {
        NavigationView {
            List(api.supportedLanguages.data.languages, id: \.self) { language in
                Button(action: {
                    target = language
                    shouldPerformRequest = true
                    isPresent.toggle()
                }, label: {
                    Text(language.name.capitalized)
                })
            }
            .navigationBarTitle("Supported Languages", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                isPresent.toggle()
            }, label: {
                Text("Close")
            }))
        }
    }
}

struct SupportedLanguagesView_Previews: PreviewProvider {
    static var previews: some View {
        SupportedLanguagesView(isPresent: .constant(true), target: .constant(Language(language: "en", name: "english")), shouldPerformRequest: .constant(true))
    }
}
