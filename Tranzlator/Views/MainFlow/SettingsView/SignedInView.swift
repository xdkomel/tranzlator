//
//  SignedInView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 715..2021.
//

import SwiftUI

struct SignedInView: View {
    @EnvironmentObject var signDelegate: GoogleIDSignInDelegate
    let imageSize: CGFloat = 120.0
    var body: some View {
        VStack {
            Group {
                if let image = signDelegate.avatar {
                    image
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .scaledToFit()
                        .cornerRadius(imageSize/2)
                } else {
                    Circle()
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: imageSize, height: imageSize)
                        .overlay(Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("TranslationCardColor"))
                            .frame(width: imageSize/3, height: imageSize/3))
                }
            }.padding()
            
            Text("Welcome, \(signDelegate.profile.fullName ?? "No One")")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.horizontal)
            Button(action: {
                signDelegate.signOut()
            }, label: {
                Text("Sign out")
                    .padding()
                    .foregroundColor(.red)
            })
            Spacer()
        }
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInView().environmentObject(GoogleIDSignInDelegate())
    }
}
