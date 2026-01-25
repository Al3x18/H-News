# HNews

A SwiftUI training application for browsing Hacker News stories.

## Description

HNews is a training/practice iOS/macOS application built with SwiftUI that fetches and displays the latest stories from Hacker News API. This project serves as a learning exercise to practice SwiftUI development, MVVM architecture, and API integration. The app provides a clean and modern interface to browse through the newest stories posted on Hacker News.

## Features

- Fetch and display new stories from Hacker News
- Modern SwiftUI interface
- MVVM architecture pattern
- Async/await for network requests
- Settings view for app configuration

## Project Structure

```
HNews/
├── HNewsApp.swift          # Main app entry point
├── Model/
│   └── Story.swift         # Data models
├── Services/
│   └── APIService.swift    # API service for Hacker News
├── View/
│   ├── Components/         # Reusable UI components
│   ├── HNews.swift         # Main view
│   └── Settings.swift      # Settings view
└── ViewModel/
    ├── NewsViewModel.swift
    └── SettingsViewModel.swift
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 14.0+
- Swift 5.7+

## API

This app uses the [Hacker News API](https://github.com/HackerNews/API) to fetch stories.

## License

This project is available for personal use.
