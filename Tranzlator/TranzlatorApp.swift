//
//  TranzlatorApp.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 625..2021.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct TranzlatorApp: App {
    @StateObject var signDelegate = GoogleIDSignInDelegate()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(signDelegate)
        }
    }
}

