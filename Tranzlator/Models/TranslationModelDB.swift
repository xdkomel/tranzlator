//
//  TranslationModelDB.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 710..2021.
//

import Foundation
import RealmSwift

class TranslationModelDB: Object {
    @objc dynamic var id: UUID
    @objc dynamic var date: Date
    @objc dynamic var originalText: String
    @objc dynamic var translatedText: String
    @objc dynamic var sourceLangCode: String
    @objc dynamic var targetLangCode: String
    @objc dynamic var targetLangName: String
    
    init(_ text: String, fromText original: String, fromLanguage source: String, toLanguageNamed targetName: String, toLanguagedCoded targetCode: String) {
        self.id = UUID()
        self.originalText = original
        self.translatedText = text
        self.sourceLangCode = source
        self.targetLangName = targetName
        self.targetLangCode = targetCode
        self.date = Date(timeIntervalSinceNow: 0)
    }
    
    override init() {
        self.id = UUID()
        self.date = Date(timeIntervalSinceNow: 0)
        self.originalText = ""
        self.translatedText = ""
        self.sourceLangCode = ""
        self.targetLangCode = ""
        self.targetLangName = ""
    }
    
    override static func primaryKey() -> String? {
        "id"
    }
    
    static func == (lhs: TranslationModelDB, rhs: TranslationModelDB) -> Bool {
        return
            lhs.originalText == rhs.originalText
    }
}
