//
//  SafariView.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    let settingsViewModel: SettingsViewModel
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = settingsViewModel.entersReaderIfAvailable
        
        let safariVC = SFSafariViewController(url: url, configuration: config)
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Update configuration if settings change while view is open
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = settingsViewModel.entersReaderIfAvailable
    }
}
