//
//  ContentView.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import SwiftUI

// MARK: - URL Item for Sheet
struct URLItem: Identifiable {
    let id = UUID()
    let url: URL
}

struct HNews: View {
    @State private var settingsViewModel = SettingsViewModel()
    @State private var newsViewModel = NewsViewModel()
    @State private var selectedURLItem: URLItem? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                if newsViewModel.isLoading {
                    //MARK: - Loading View
                    Loading()
                        .background(settingsViewModel.effectiveBackgroundColor)
                } else if let error = newsViewModel.errorMessage {
                    //MARK: - Error View
                    Error(error: error, newsViewModel: newsViewModel)
                        .background(settingsViewModel.effectiveBackgroundColor)
                } else {
                    //MARK: - News List View
                    News(
                        viewModel: newsViewModel,
                        selectedURLItem: $selectedURLItem,
                        accentColor: settingsViewModel.accentColor
                    )
                    .listStyle(.plain)
                    .background(settingsViewModel.effectiveBackgroundColor)
                    .sheet(item: $selectedURLItem) { item in
                        SafariView(url: item.url, settingsViewModel: settingsViewModel)
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "newspaper.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [settingsViewModel.accentColor, settingsViewModel.accentColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("H News")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Task { await loadNews() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.primary)
                            .opacity(newsViewModel.isLoading ? 0.5 : 1)
                    }
                    .disabled(newsViewModel.isLoading)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(settingsViewModel: settingsViewModel, newsViewModel: newsViewModel)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                }
            }
            .refreshable {
                Task { await loadNews() }
            }
        }
    }
    
    func loadNews() async {
        await newsViewModel.loadNewStories()
    }
}

#Preview {
    HNews()
}
