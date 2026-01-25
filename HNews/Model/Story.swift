//
//  Story.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import Foundation

struct Story: Codable, Identifiable {
    var by: String
    var descendants: Int
    var id: Int
    var score : Int?
    var time: Int?
    var title: String
    var type : String
    var url : String?
}

struct newStoriesID: Codable {
    var storyID: Int
}

/*
{
    "by": "dorianmariecom",
    "descendants": 0,
    "id": 46755315,
    "score": 1,
    "time": 1769357448,
    "title": "What posting Rails UI to Hacker News taught me",
    "type": "story",
    "url": "https://railsui.com/blog/what-finally-posting-rails-ui-to-hacker-news-taught-me"
}
*/
