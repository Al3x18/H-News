//
//  HNewsApp.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import SwiftUI
import SwiftData

@main
struct HNewsApp: App {
    var body: some Scene {
        WindowGroup {
            HNews()
        }
        .modelContainer(for: FavoriteStory.self)
    }
}
