//
//  ContentView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 625..2021.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var signDelegate: GoogleIDSignInDelegate
    var body: some View {
        MainView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
