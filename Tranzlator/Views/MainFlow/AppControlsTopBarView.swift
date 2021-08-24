//
//  AppControlsTopBar.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 78..2021.
//

import SwiftUI

struct AppControlsTopBarView: View {
    @EnvironmentObject var api: API
    @EnvironmentObject var signDelegate: GoogleIDSignInDelegate
    @EnvironmentObject var translationsDB: TranslationsDB
    @State var isSettingsOpen = false
    @State var isLibraryOpen = false
    @Binding var q: String
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    isLibraryOpen.toggle()
                }, label: {
                    Image(systemName: "book")
                        .foregroundColor(Color("TopButtonsColor"))
                        .padding()
                })
                Spacer()
            }
            Text("tranzlator").bold()
                .foregroundColor(.white)
            HStack {
                Spacer()
                Button(action: {
                    isSettingsOpen.toggle()
                }, label: {
                    Image(systemName: "gear")
                        .foregroundColor(Color("TopButtonsColor"))
                        .padding()
                })
            }
        }
        .sheet(isPresented: $isSettingsOpen) {
            SettingsView(isPresent: $isSettingsOpen).environmentObject(api).environmentObject(signDelegate)
            
        }
        .sheet(isPresented: $isLibraryOpen) {
            LibraryView(
                isPresent: $isLibraryOpen,
                q: $q
            ).environmentObject(translationsDB).environmentObject(api)
        }
    }
}

struct AppControlsTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppControlsTopBarView(q: .constant("")).previewLayout(.sizeThatFits).background(Color(.blue))
    }
}
