//
//  CurrentDateView.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 713..2021.
//

import SwiftUI

struct CurrentDateView: View {
    var date: String
    var body: some View {
        Text(date).foregroundColor(.blue)
    }
}

struct CurrentDateView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDateView(date: "Jule 12")
    }
}
