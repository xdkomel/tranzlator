//
//  TranslationView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 77..2021.
//

import SwiftUI
import GoogleSignIn

struct TranslationView: View {
    @EnvironmentObject var translationsDB: TranslationsDB
    @EnvironmentObject var api: API
    @EnvironmentObject var signDelegate: GoogleIDSignInDelegate
    @Binding var q: String
    @State var target: Language = Language(language: "ru", name: "russian")
    @State var shouldPerformRequest: Bool = false
    @State var editor = UITextView()
    @Binding var shouldClearTheInput: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .foregroundColor(Color("TranslationCardColor"))
                .shadow(radius: 16)
            VStack {
                ActiveLanguagesView(target: $target, shouldPerformRequest: $shouldPerformRequest, q: $q)
                    .padding()
                MultilineTextField(text: $q, shouldPerformRequest: $shouldPerformRequest, editor: $editor)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color("TextEditorBackgroundColor"))
                    .font(.title)
                ScrollView {
                    HStack {
                        TranslatedTextView()
                            .padding()
                            .font(.title)
                            
                        Spacer()
                    }
                    Spacer()
                }.onTapGesture {
                    editor.resignFirstResponder()
                }
            }
        }.onChange(of: shouldPerformRequest) { value in
            if shouldPerformRequest {
                performTranslationRequest()
                shouldPerformRequest = false
            }
        }.onChange(of: shouldClearTheInput) { value in
            if shouldClearTheInput {
                q = ""
                api.translationController.dataModel = nil
                shouldClearTheInput.toggle()
            }
        }.onAppear {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error == nil {
                    signDelegate.setProfileAndToken(withUser: user!, token: user?.authentication.accessToken) {
                        api.token = signDelegate.token
                        signDelegate.state = .IN
                    }
                } else {
                    log("sign in restore error", "\(error?.localizedDescription)")
                }
            }
            performSupportedLanguagesRequest()
        }
    }
    
    func performSupportedLanguagesRequest() {
        api.performSupportedLanguagesRequest(targetLanguage: "en")
    }
    
    func performTranslationRequest() {
        api.performTranslationRequest(self.q, target: self.target.language, completion: {
            translationsDB.add(
                translatedText: (self.api.translationController.dataModel?.data.translations[0].translatedText)!,
                originalText: self.q,
                fromLanguage: (self.api.translationController.dataModel?.data.translations[0].detectedSourceLanguage)!,
                toLanguageNamed: self.target.name,
                toLanguageCoded: self.target.language,
                completion: { result in
                    print(result)
                }
            )
            api.loadToCloud(
                signDelegate.state,
                translatedText: (self.api.translationController.dataModel?.data.translations[0].translatedText)!,
                originalText: self.q,
                fromLanguage: (self.api.translationController.dataModel?.data.translations[0].detectedSourceLanguage)!,
                toLanguageNamed: self.target.name,
                toLanguageCoded: self.target.language
            ) 
        })
    }
}

struct TranslationView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView(q: .constant(""), shouldClearTheInput: .constant(false))
            .environmentObject(GoogleIDSignInDelegate()).environmentObject(API())
    }
}



