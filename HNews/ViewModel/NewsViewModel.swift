//
//  StoriesViewModel.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import Foundation

@MainActor
@Observable
final class NewsViewModel {
    private let api = APIService()
    
    var stories: [Story] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var dateLocale: DateLocale = .enUS
    
    init() {
        Task {
            await loadNewStories()
        }
    }
    
    func loadNewStories() async {
        isLoading = true
        
        do {
            let IDs = try await api.fetchNewStories()
            
            for elem in IDs.prefix(50) {
                do {
                    let story = try await api.fetchStory(id: elem.storyID)
                    stories.append(story)
                } catch {
                    print("Failed to fetch story \(elem.storyID): \(error)")
                }
            }
            
        } catch {
            errorMessage = "Failed to fetch stories"
            print("loadNewStories error: \(error)")
        }
        
        isLoading = false
    }
    
    /// Converts a Unix timestamp to a formatted date string
    /// - Parameter timestamp: Unix timestamp in seconds
    /// - Returns: A formatted date string like "25 gennaio 2026, 14:30"
    func formattedDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: dateLocale.locale)
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

enum DateLocale: CaseIterable {
    case itIT
    case enUS
    
    var locale: String {
        switch self {
        case .itIT:
            return "it_IT"
        case .enUS:
            return "en_US"
        }
    }
    
    var localeForPicker: String {
        switch self {
        case .itIT:
            return "IT"
        case .enUS:
            return "US"
        }
    }
}
