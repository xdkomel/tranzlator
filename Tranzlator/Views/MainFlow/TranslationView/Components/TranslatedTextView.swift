//
//  TranslatedTextView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 79..2021.
//

import Foundation
import SwiftUI

struct TranslatedTextView: View {
    @EnvironmentObject var api: API
    var body: some View {
        ZStack {
            if api.translationController.isLoading {
                HStack {
                    Spacer()
                    ProgressView().padding()
                    Spacer()
                }
            } else {
                Text(
                    api.translationController.result?.isSucceed ?? true ?
                        api.translationController.dataModel?.data.translations[0].translatedText ?? "The translated text will be displayed here" :
                        api.translationController.result?.error?.uiDescription ?? "Something went wrong"
                ).multilineTextAlignment(.leading).foregroundColor( { () -> Color in
                    api.translationController.result?.isSucceed ?? true ?
                        api.translationController.dataModel != nil ?
                            .primary :
                            .secondary :
                        .red
                }() )
            }
        }
        
    }
}
