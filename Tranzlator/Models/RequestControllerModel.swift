//
//  RequestControllerModel.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 79..2021.
//

import Foundation

struct RequestControllerModel<T> {
    var dataModel: T? = nil
    var isLoading: Bool = false
    var result: RequestResult? = nil
}

struct RequestResult {
    var isSucceed: Bool
    var error: RequestError?
}

struct RequestError {
    var description: String
    var uiDescription: String
}
