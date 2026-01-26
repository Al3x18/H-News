//
//  Error.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import SwiftUI

struct Error: View {
    var error: String
    @Bindable var newsViewModel: NewsViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text(error)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
            Button("Retry") {
                Task {
                    await newsViewModel.loadNewStories()
                }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
