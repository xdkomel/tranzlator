//
//  MultilineTextField.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 77..2021.
//

import SwiftUI
import Introspect
import UITextView_Placeholder

struct MultilineTextField: View {
    @Binding var text: String
    @Binding var shouldPerformRequest: Bool
    @State var height: CGFloat = 100.0
    @Binding var editor: UITextView 
    @State var hasEditorBeenSet = false
    
    var body: some View {
        ZStack {
            TextEditor(text: $text)
                .introspectTextView(customize: { it in
                    self.editor = it
                    editor.backgroundColor = UIColor(Color("TextEditorBackgroundColor"))
                    editor.returnKeyType = .done
                    editor.isScrollEnabled = true
                    editor.placeholder = "Enter the text"
                    if !hasEditorBeenSet {
                        self.height = self.editor.sizeThatFits(CGSize(width: editor.frame.width, height: .infinity)).height
                        hasEditorBeenSet.toggle()
                    }
                })
                .frame(height: self.height)
                .onChange(of: self.text, perform: onTextChange(_:))
            HStack {
                Spacer()
                Button(action: {
                    if let pastedText = UIPasteboard.general.string {
                        text = pastedText
                    }
                }, label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(Color("AccentColor"))
                }).opacity(text == "" ? 1.0 : 0.0)
            }
        }
    }
    
    func onTextChange(_: String) {
        adjustEditorSize()
        onReturnPress()
    }
    
    func onReturnPress() {
        if (self.text.last ?? " ") == "\n" {
            self.text = String(self.text.dropLast())
            requestTheTranslation()
        } else {
            for i in text.indices {
                if text[i] == "\n" {
                    text.remove(at: i)
                    requestTheTranslation()
                    return
                }
            }
        }
    }
    
    func requestTheTranslation() {
        editor.resignFirstResponder()
        self.shouldPerformRequest = true
    }
    
    func adjustEditorSize() {
        let numLines = editor.contentSize.height / editor.font!.lineHeight
        self.height = numLines > 4 ?
            editor.font!.lineHeight * 4 :
            editor.font!.lineHeight * numLines
    }
}

struct MultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        MultilineTextField(text: .constant(""), shouldPerformRequest: .constant(false), editor: .constant(UITextView()))
    }
}
