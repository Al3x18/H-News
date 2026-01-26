//
//  SettingsViewModel.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    // We can't use '@AppStorage' in this class because '@Observable' and '@AppStorage' are not supported together
    // so for persistence we use 'UserDefaults' and 'didSet'
    
    private static let defaultColor: Color = Color(uiColor: .systemBackground)
    private static let defaultAccentColor: Color = Color(red: 0.0, green: 0.478, blue: 1.0) // iOS blue
    
    var backgroundEnabled: Bool = false {
        didSet {
            UserDefaults.standard.set(backgroundEnabled, forKey: "backgroundEnabled")
        }
    }
    
    var entersReaderIfAvailable: Bool = true {
        didSet {
            UserDefaults.standard.set(entersReaderIfAvailable, forKey: "entersReaderIfAvailable")
        }
    }
    
    // Background Color Settings
    /// This is a custom persistence
    /// with old method 'UserDeaults' and an extension on 'UserDefaults' to support color
    var backgroundColor: Color = SettingsViewModel.defaultColor {
        didSet {
            if backgroundEnabled {
                UserDefaults.standard.set(backgroundColor, forKey: "backgroundColor")
            }
        }
    }
    
    // Computed property for the actual background color to use
    var effectiveBackgroundColor: Color {
        backgroundEnabled ? backgroundColor : SettingsViewModel.defaultColor
    }
    
    // Accent Color Settings
    var accentColor: Color = SettingsViewModel.defaultAccentColor {
        didSet {
            UserDefaults.standard.set(accentColor, forKey: "accentColor")
        }
    }
    
    //MARK: - Init
    init() {
        // Load saved values
        backgroundEnabled = UserDefaults.standard.bool(forKey: "backgroundEnabled")
        entersReaderIfAvailable = UserDefaults.standard.bool(forKey: "entersReaderIfAvailable")
        
        // Load saved color or use default
        if let savedColor = UserDefaults.standard.color(forKey: "backgroundColor") {
            backgroundColor = savedColor
        }
        
        // Load saved accent color or use default
        if let savedAccentColor = UserDefaults.standard.color(forKey: "accentColor") {
            accentColor = savedAccentColor
        }
    }
}

// MARK: - UserDefaults Extension for Color
extension UserDefaults {
    func set(_ color: Color, forKey key: String) {
        let uiColor = UIColor(color)
        
        // Convert to RGB color space to ensure we can extract components
        guard let rgbColor = uiColor.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil) else {
            // Fallback: try to get components directly
            if let components = uiColor.cgColor.components, components.count >= 4 {
                let colorData = [
                    "red": components[0],
                    "green": components[1],
                    "blue": components[2],
                    "alpha": components[3]
                ]
                set(colorData, forKey: key)
            }
            return
        }
        
        let components = rgbColor.components ?? []
        guard components.count >= 4 else { return }
        
        let colorData = [
            "red": components[0],
            "green": components[1],
            "blue": components[2],
            "alpha": components[3]
        ]
        
        set(colorData, forKey: key)
    }
    
    func color(forKey key: String) -> Color? {
        guard let colorData = dictionary(forKey: key) as? [String: CGFloat],
              let red = colorData["red"],
              let green = colorData["green"],
              let blue = colorData["blue"],
              let alpha = colorData["alpha"] else {
            return nil
        }
        
        return Color(
            red: Double(red),
            green: Double(green),
            blue: Double(blue),
            opacity: Double(alpha)
        )
    }
}
