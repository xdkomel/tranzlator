//
//  NotSignedInView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 715..2021.
//

import SwiftUI

struct NotSignedInView: View {
    @EnvironmentObject var signDelegate: GoogleIDSignInDelegate
    @EnvironmentObject var api: API
    @Binding var isPresent: Bool
    var body: some View {
        VStack {
            Text("If you sign in, you will be able to use cloud storage")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding()
            Button(action: {
                isPresent.toggle()
                signDelegate.signIn() {
                    api.token = signDelegate.token
                    log("api update", "api.token has been syncronized")
                }
            }, label: {
                Text("Sign in with Google")
                    .padding()
                    .background(Color("AccentColor"))
                    .foregroundColor(Color("TranslationCardColor"))
                    .cornerRadius(16.0)
            })
        }
    }
}

struct NotSignedInView_Previews: PreviewProvider {
    static var previews: some View {
        NotSignedInView(isPresent: .constant(true))
            .preferredColorScheme(.light)
            .environmentObject(GoogleIDSignInDelegate())
            .environmentObject(API())
    }
}
