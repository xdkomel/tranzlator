//
//  SettingsView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 78..2021.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var signDelegate: GoogleIDSignInDelegate
    @EnvironmentObject var api: API
    @Binding var isPresent: Bool
    var body: some View {
        NavigationView {
            Group {
                if signDelegate.state == .IN {
                    SignedInView().environmentObject(signDelegate)
                } else {
                    NotSignedInView(isPresent: $isPresent).environmentObject(signDelegate).environmentObject(api)
                }
            }.navigationBarTitle("Settings")
            .navigationBarItems(leading: Button(action: {
                isPresent.toggle()
            }, label: {
                Text("Close")
            }))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresent: .constant(true)).environmentObject(API())
    }
}
