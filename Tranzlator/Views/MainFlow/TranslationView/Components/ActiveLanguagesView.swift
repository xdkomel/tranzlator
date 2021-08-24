//
//  ActiveLanguagesView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 77..2021.
//

import Foundation
import SwiftUI

struct ActiveLanguagesView: View {
    @EnvironmentObject var api: API
    @Binding var target: Language
    @Binding var shouldPerformRequest: Bool
    @Binding var q: String
    @State var isSupportedLanguagesSheetPresented = false
    var body: some View {
        HStack {
            HStack {
                Spacer()
                Text(api.formLanguageName(
                    fromCode: api.translationController.dataModel?.data.translations[0].detectedSourceLanguage
                ).capitalized)
            }
            Button(action: {
                self.target = Language(
                    language: api.translationController.dataModel?.data.translations[0].detectedSourceLanguage ?? "en",
                    name: api.formLanguageName(
                        fromCode: api.translationController.dataModel?.data.translations[0].detectedSourceLanguage
                    )
                )
                q = api.translationController.dataModel?.data.translations[0].translatedText ?? ""
                shouldPerformRequest = true
            }, label: {
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundColor(Color("AccentColor"))
                    .padding(.horizontal, 8)
                    .opacity(api.translationController.dataModel == nil ? 0.3 : 1.0)
            }).disabled(api.translationController.dataModel == nil)
            HStack {
                Button(action: {
                    isSupportedLanguagesSheetPresented.toggle()
                }, label: {
                    Text(target.name.capitalized)
                        .foregroundColor(Color("AccentColor"))
                })
                
                Spacer()
            }
        }.sheet(isPresented: $isSupportedLanguagesSheetPresented, content: {
            SupportedLanguagesView(isPresent: $isSupportedLanguagesSheetPresented, target: $target, shouldPerformRequest: $shouldPerformRequest).environmentObject(api)
        })
    }
}
