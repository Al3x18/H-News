//
//  Loading.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//
import SwiftUI

struct Loading: View {
    var body: some View {
        VStack {
            ProgressView()
                .foregroundStyle(.primary)
            Text("Loading stories...")
                .foregroundStyle(.primary)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
