//
//  API.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 77..2021.
//

import Foundation
import Alamofire
import SwiftUI
import Firebase
import GoogleSignIn

extension DispatchQueue {
    static func execute(background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    completion()
                })
            }
        }
    }
}

extension Dictionary {
    func merge(_ dict: [Key : Value]) -> [Key : Value] {
        var merged = self
        for (k, v) in dict {
            merged[k] = v
        }
        return merged
    }
}

class API: ObservableObject {
    @Published var translationController: RequestControllerModel<TranslationModel> = RequestControllerModel()
    @Published var supportedLanguages: SupportedLanguagesModel = SupportedLanguagesModel(data: .init(languages: [
        Language(language: "ru", name: "russian"),
        Language(language: "en", name: "english")
    ]))
    
    let translationUrl = "https://translation.googleapis.com/language/translate/v2"
    let languagesUrl = "https://translation.googleapis.com/language/translate/v2/languages"
    let api_key = "AIzaSyAcv9Ww6AtefX1vKHkGZAwqvHg4Hg7iJ-s"
    let unknownLanguage = "unknown"
    var token: String? = nil
    
    func loadToCloud(
        _ state: SignState,
        translatedText: String,
        originalText: String,
        fromLanguage: String,
        toLanguageNamed: String,
        toLanguageCoded: String
    ) {
        if state == .OUT { return }
        Firestore.firestore().collection("translations").addDocument(data: [
            "translated_text" : translatedText,
            "original_text" : originalText,
            "from_language" : fromLanguage,
            "to_language_named" : toLanguageNamed,
            "to_language_coded" : toLanguageCoded,
            "date" : Date(timeIntervalSinceNow: 0)
        ])
        log("firebase", "did load to cloud")
    }
    
    func formLanguageName(fromCode code: String?) -> String {
        return code == nil ?
            unknownLanguage :
            supportedLanguages.data.languages.first(where: { language in
                language.language == code
            })?.name ?? unknownLanguage
    }
    
    func formAccessParameter() -> [String : String] { [
        (token == nil ? "key" : "access_token") : token ?? api_key
    ] }
    
    func formTranslationParameters(_ q: String, _ target: String) -> [String : String] { [
        "q" : q,
        "target" : target
    ].merge(formAccessParameter()) }
    
    func performTranslationRequest(_ q: String, target: String, completion: @escaping () -> Void) {
        if q == "" || q.allSatisfy({ !$0.isLetter }) { return } // проверка входных данных
        self.translationController.isLoading = true // переводим UI в загрузку
        log("granted scopes", GIDSignIn.sharedInstance.currentUser?.grantedScopes) // проверяем скоупы
        performGetRequest(
            self.translationUrl, // GET запрос по этой ссылке
            params: self.formTranslationParameters(q, target), // параметры для перевода
            model: TranslationModel.self, // модель для парсинга
            completion: { newValue, result in
                if !result.isSucceed { // ветка, когда запрос не удался
                    print(result.error?.description ?? "no error description")
                    log("new value", newValue)
                } // когда удался, UI контроллер обновляется
                self.translationController = .init(dataModel: newValue, isLoading: false, result: result)
                log("request", "translation is updated")
                completion()
            }
        )
    }
    
    func formSupportedLanguagesParameters(_ target: String) -> [String : String] { [
        "target" : target
    ].merge(formAccessParameter()) }
    
    func performSupportedLanguagesRequest(targetLanguage target: String) {
        performGetRequest(
            self.languagesUrl,
            params: self.formSupportedLanguagesParameters(target),
            model: SupportedLanguagesModel.self,
            completion: { newValue, result in
                if newValue != nil {
                    self.supportedLanguages = newValue!
                }
                log("request", "supported languages are updated")
            }
        )
    }
    
    
    private func performGetRequest<T>(
        _ url: String,
        params: [String : String],
        model: T.Type,
        completion: @escaping (T?, RequestResult) -> Void
    ) where T : Decodable {
        AF.request(url, method: .get, parameters: params)
            .responseJSON(completionHandler: { response in
                print(response)
                print(params)
                switch response.result {
                case .failure(_):
                    completion(nil, RequestResult(isSucceed: false, error: RequestError(
                        description: "the response is failed",
                        uiDescription: "Something is wrong with the server"
                    )))
                default:
                    do {
                        let json = try JSONDecoder().decode(model , from: response.data!)
                        print(json)
                        completion(json, RequestResult(isSucceed: true, error: nil))
                    } catch _ {
                        completion(nil, RequestResult(isSucceed: false, error: RequestError(
                            description: "the decoder is failed",
                            uiDescription: "Something is wrong with your access token, try to sign in again"
                        )))
                    }
                }
            })
    }
    
}
