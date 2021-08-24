//
//  SupportedLanguagesModel.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 78..2021.
//

import Foundation

// MARK: - SupportedLanguagesModel
struct SupportedLanguagesModel: Codable {
    let data: SupportedLanguagesData
}

// MARK: - DataClass
struct SupportedLanguagesData: Codable {
    let languages: [Language]
}

// MARK: - Language
struct Language: Codable, Hashable {
    let language, name: String
}

