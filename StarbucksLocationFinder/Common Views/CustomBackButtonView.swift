//
//  CustomBackButton.swift
//  StarbucksLocationFinder
//
//  Created by Manu on 30/01/24.
//

import SwiftUI
struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left.circle.fill")
                Text("Back")
            }
        }
    }
}
