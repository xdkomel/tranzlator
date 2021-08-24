//
//  TranslationsDB.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 710..2021.
//

import Foundation
import RealmSwift

class TranslationsDB: ObservableObject {
    var realm: Realm
    @Published var data: [TranslationModelDB] = []
    
    init(){
        realm = try! Realm()
        updateData()
    }
    
    func add(
        translatedText: String,
        originalText: String,
        fromLanguage sourceLanguage: String,
        toLanguageNamed targetName: String,
        toLanguageCoded targetCode: String,
        completion: (Result<Any, Error>) -> Void
    ) {
        completion(Result(catching: {
            try realm.write {
                realm.add(TranslationModelDB(
                    translatedText,
                    fromText: originalText,
                    fromLanguage: sourceLanguage,
                    toLanguageNamed: targetName,
                    toLanguagedCoded: targetCode
                ))
            }
        }))
        data.insert(.init(
            translatedText,
            fromText: originalText,
            fromLanguage: sourceLanguage,
            toLanguageNamed: targetName,
            toLanguagedCoded: targetCode
        ), at: 0)
        data = appendUniqueValueToArray(data: data)
    }
    
    private func getLibrary() -> [TranslationModelDB] {
        return realm
            .objects(TranslationModelDB.self)
            .toArray(ofType: TranslationModelDB.self) as [TranslationModelDB]
    }
    private func updateData() {
        realm.refresh()
        log("database", formUniqueDataArray(data: self.getLibrary()))
        self.data = formUniqueDataArray(data: self.getLibrary())
    }
    private func formUniqueDataArray(data: [TranslationModelDB]) -> [TranslationModelDB] {
        var newData: [TranslationModelDB] = []
        for item in data {
            var missAnExternalIteration = false
            for each in newData {
                if each == item {
                    missAnExternalIteration = true
                    break
                }
            }
            if !missAnExternalIteration {
                newData.append(item)
            }
        }
        return newData
    }
    private func appendUniqueValueToArray(data: [TranslationModelDB]) -> [TranslationModelDB] {
        var newData: [TranslationModelDB] = data
        for i in 1..<newData.count {
            if newData[i] == newData[0] {
                newData.remove(at: i)
                return newData
            }
        }
        return newData
    }
}


extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
