//
//  TranslationModel.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 77..2021.
//

import Foundation

// MARK: - TranslationModel
struct TranslationModel: Codable {
    let data: TranslationData 
}

// MARK: - DataClass
struct TranslationData: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}


extension TranslationModel {
    init(db: TranslationModelDB) {
        self.init(data: .init(translations: [
            .init(translatedText: db.translatedText, detectedSourceLanguage: db.sourceLangCode)
        ]))
    }
}
