//
//  GoogleIDSignIn.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 76..2021.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI
import Kingfisher

enum SignState: String {
    case IN = "in"
    case OUT = "out"
}

class GoogleIDSignInDelegate: NSObject, ObservableObject {
    @Published var state: SignState = .OUT
    var profile: ProfileModel = ProfileModel()
    var token: String? = nil
    var avatar: KFImage? = nil
    
    let signInConfig = GIDConfiguration(clientID: (FirebaseApp.app()?.options.clientID)!)
    let scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/cloud-translation"
    ]
    
    
    func signIn(completion: @escaping () -> Void) {
        if GIDSignIn.sharedInstance.currentUser != nil {
            log("sign in", "alreads is as \(GIDSignIn.sharedInstance.currentUser?.profile?.name)")
            return
        }
        
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: viewController) { user, error in
            if error == nil {
                self.firebaseAuthentication(withUser: user!) {
                    self.setScopes(presenter: viewController) { token in
                        self.setProfileAndToken(withUser: user!, token: token) {
                            completion()
                        }
                    }
                }
            } else {
                if error?.asAFError?.responseCode == GIDSignInError.hasNoAuthInKeychain.rawValue {
                    print("The user has not signed in before or they have since signed out")
                } else {
                    print("DEBUG DESCRIPTION:")
                    print(error.debugDescription)
                }
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            state = .OUT
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }
    
    func setScopes(presenter: UIViewController, completion: @escaping (String?) -> Void) {
        GIDSignIn.sharedInstance.addScopes(scopes, presenting: presenter) { user, error in
            log("current user", user?.grantedScopes)
            log("scopes", error == nil ? "succesfully" : error?.localizedDescription)
            user?.authentication.do { authentication, error in
                completion(authentication?.accessToken)
            }
            
        }
    }
    func setProfileAndToken(withUser user: GIDGoogleUser, token: String?, completion: @escaping () -> Void) {
        profile.userID = user.userID
        profile.email = user.profile?.email
        profile.familyName = user.profile?.familyName
        profile.fullName = user.profile?.name
        profile.givenName = user.profile?.givenName
        self.token = token
        avatar = KFImage(user.profile?.imageURL(withDimension: 512))
        completion()
    }
    private func firebaseAuthentication(withUser user: GIDGoogleUser, completion: @escaping () -> Void) {
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(
            withIDToken: authentication.idToken!,
            accessToken: authentication.accessToken
        )
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.state = .IN
                completion()
            }
        }
    }
    
}
