//
//  MainView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 77..2021.
//

import Foundation
import SwiftUI
import Introspect

class TemporaryViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

struct MainView: View {
    @EnvironmentObject var signDelegate: GoogleIDSignInDelegate
    @StateObject var api: API = API()
    @StateObject var translationsDB = TranslationsDB()
    @State var translationViewRotationDegrees = 0.0
    @State var shouldClearTheInput = false
    @State var q: String = ""
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
                .gesture(deletionDragGesture())
            HStack {
                Text(deletionHintText()).padding().foregroundColor(.white).shadow(radius: 16.0)
                Spacer()
            }
            VStack {
                AppControlsTopBarView(q: $q).font(.title3)
                    .environmentObject(api)
                    .environmentObject(translationsDB)
                TranslationView(q: $q, shouldClearTheInput: $shouldClearTheInput)
                    .environmentObject(api)
                    .environmentObject(translationsDB)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    .rotation3DEffect(
                        .init(degrees: translationViewRotationDegrees),
                        axis: (0.0, 1.0, 0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
            }
        }.ignoresSafeArea(.keyboard)
    }
    
    func deletionHintText() -> String {
        "\(translationViewRotationDegrees < -90.0 ? "Release" : "Swipe left")\nto clear"
    }
    
    func deletionDragGesture() -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
            .onChanged({ value in
                translationViewRotationDegrees = Double(value.translation.width/2)
            })
            .onEnded({ value in
                var initialAngle = 0.0
                if value.translation.width < -180.0 {
                    shouldClearTheInput = true
                    initialAngle = -360
                }
                withAnimation(.spring(
                    response: 0.4,
                    dampingFraction: 0.5,
                    blendDuration: 0.4
                )) {
                    translationViewRotationDegrees = initialAngle
                }
            })
    }
    
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(GoogleIDSignInDelegate())
    }
}
