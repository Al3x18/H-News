//
//  StoriesViewModel.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class NewsViewModel {
    // We can't use '@AppStorage' in this class because '@Observable' and '@AppStorage' are not supported together
    // so for persistence we use 'UserDefaults' and 'didSet'
    
    private let api = APIService()
    
    var stories: [Story] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    var loadLimit: Int = 40 {
        didSet {
            UserDefaults.standard.set(loadLimit, forKey: "load_limit")
        }
    }
    
    var dateLocale: DateLocale = .enUS {
        didSet {
            UserDefaults.standard.set(dateLocale.rawValue, forKey: "date_locale")
        }
    }
    //MARK: - Init
    init() {
        // Load saved locale or use default
        if let savedLocaleString = UserDefaults.standard.string(forKey: "date_locale"),
           let savedLocale = DateLocale(rawValue: savedLocaleString) {
            dateLocale = savedLocale
        }
        
        // Load saved loadLimit if it exists, otherwise keep default (40)
        if UserDefaults.standard.object(forKey: "load_limit") != nil {
            let savedLimit = UserDefaults.standard.integer(forKey: "load_limit")
            if savedLimit > 0 {
                loadLimit = savedLimit
            }
        }
        
        Task {
            await loadNewStories()
        }
    }
    
    //MARK: - Functions
    func loadNewStories() async {
        isLoading = true
        errorMessage = nil
        stories = []
        
        do {
            let IDs = try await api.fetchNewStories()
            let idsToLoad = Array(IDs.prefix(loadLimit))
            
            // Load stories concurrently using TaskGroup
            // This significantly speeds up loading by making multiple API calls in parallel
            let loadedStories = await withTaskGroup(of: (Int, Story?).self, returning: [Story].self) { group in
                // Add all tasks to the group
                for (index, elem) in idsToLoad.enumerated() {
                    group.addTask {
                        do {
                            let story = try await self.api.fetchStory(id: elem.storyID)
                            return (index, story)
                        } catch {
                            print("Failed to fetch story \(elem.storyID): \(error)")
                            return (index, nil)
                        }
                    }
                }
                
                // Collect results and maintain order
                var results: [(Int, Story)] = []
                for await result in group {
                    if let story = result.1 {
                        results.append((result.0, story))
                    }
                }
                
                // Sort by original index to maintain order
                return results.sorted { $0.0 < $1.0 }.map { $0.1 }
            }
            
            stories = loadedStories
            
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
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

enum DateLocale: String, CaseIterable {
    case itIT
    case enUS
}

extension DateLocale {
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
