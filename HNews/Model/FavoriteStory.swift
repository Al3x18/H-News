//
//  FavoriteStory.swift
//  HNews
//
//  Created by Alex De Pasquale on 29/01/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteStory {
    var storyId: Int
    var by: String
    var descendants: Int
    var score: Int?
    var time: Int?
    var title: String
    var type: String
    var url: String?
    var savedAt: Date

    init(storyId: Int, by: String, descendants: Int, score: Int?, time: Int?, title: String, type: String, url: String?, savedAt: Date = Date()) {
        self.storyId = storyId
        self.by = by
        self.descendants = descendants
        self.score = score
        self.time = time
        self.title = title
        self.type = type
        self.url = url
        self.savedAt = savedAt
    }

    /// Creates a FavoriteStory from an API Story, used when the user saves a story to favorites.
    /// Example: `FavoriteStory(from: story)` instead of passing each property manually.
    convenience init(from story: Story) {
        self.init(
            storyId: story.id,
            by: story.by,
            descendants: story.descendants,
            score: story.score,
            time: story.time,
            title: story.title,
            type: story.type,
            url: story.url
        )
    }

    func toStory() -> Story {
        Story(
            by: by,
            descendants: descendants,
            id: storyId,
            score: score,
            time: time,
            title: title,
            type: type,
            url: url
        )
    }
}
