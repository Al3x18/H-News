//
//  APIService.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import Foundation

struct APIService {
    func fetchNewStories() async throws -> [newStoriesID] {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty") else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let IDs = try JSONDecoder().decode([Int].self, from: data)
        return IDs.map { newStoriesID(storyID: $0) }
    }
    
    func fetchStory(id: Int) async throws -> Story {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json?print=pretty") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(Story.self, from: data)
    }
}
