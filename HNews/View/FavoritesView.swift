//
//  FavoritesView.swift
//  HNews
//
//  Created by Alex De Pasquale on 29/01/26.
//

import SwiftUI

struct FavoritesView: View {
    @Bindable var newsViewModel: NewsViewModel
    @Binding var urlItem: URLItem?
    var effectiveBackgroundColor: Color
    var accentColor: Color
    
    var body: some View {
        NavigationStack {
            News(
                type: .favorites,
                isFavView: true,
                viewModel: newsViewModel,
                selectedURLItem: $urlItem,
                accentColor: accentColor
            )
            .listStyle(.plain)
            .background(effectiveBackgroundColor)
        }
        .navigationTitle("Favorites")
    }
}
