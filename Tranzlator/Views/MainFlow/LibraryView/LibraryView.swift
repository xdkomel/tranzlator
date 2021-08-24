//
//  LibraryView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 710..2021.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var translationsDB: TranslationsDB
    @EnvironmentObject var api: API
    @State var currentDay = Date(timeIntervalSinceNow: 0)
    @State var sortedByDays: [DateSection : [TranslationModelDB]] = [:]
    @Binding var isPresent: Bool
    @Binding var q: String
    var body: some View {
        NavigationView {
            if !translationsDB.data.isEmpty {
                List {
                    ForEach(
                        sortedByDays.keys.sorted {
                            $0.date.compare($1.date) == .orderedDescending
                        },
                        id: \.self
                    ) { key in
                        Section(header: Text(key.dateRepr)) {
                            ForEach(sortedByDays[key]!, id: \.self) { translation in
                                Button(action: {
                                    api.performTranslationRequest(
                                        translation.originalText,
                                        target: translation.targetLangCode
                                    ) {}
                                    q = translation.originalText
                                    isPresent.toggle()
                                }, label: {
                                    LibraryElementView(
                                        translation: translation,
                                        languageNameParcer: api.formLanguageName
                                    ).padding(.vertical, 4).foregroundColor(.primary)
                                })
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Translations Library")
                .navigationBarItems(leading: Button(action: {
                    isPresent.toggle()
                }, label: {
                    Text("Close")
                }))
            } else {
                Text("No History")
            }
        }.onAppear {
            sortedByDays = .init(
                grouping: translationsDB.data.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                }),
                by: {
                    .init(date: $0.date)
                }
            )
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(
            isPresent: .constant(true), q: .constant("")
        ).environmentObject(TranslationsDB()).environmentObject(API())
    }
}
