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
    var backgroundEnabled: Bool = false {
        didSet {
            UserDefaults.standard.set(backgroundEnabled, forKey: "backgroundEnabled")
        }
    }
    
    // Safari View Settings
    var entersReaderIfAvailable: Bool = true {
        didSet {
            UserDefaults.standard.set(entersReaderIfAvailable, forKey: "entersReaderIfAvailable")
        }
    }
    
    // Background Color Settings
    var backgroundColor: Color = .orange {
        didSet {
            if backgroundEnabled {
                UserDefaults.standard.set(backgroundColor, forKey: "backgroundColor")
            }
        }
    }
    
    // Computed property for the actual background color to use
    var effectiveBackgroundColor: Color {
        backgroundEnabled ? backgroundColor : Color(uiColor: .systemBackground)
    }
    
    //MARK: - Init
    init() {
        // Load saved settings from UserDefaults
        if UserDefaults.standard.object(forKey: "entersReaderIfAvailable") != nil {
            entersReaderIfAvailable = UserDefaults.standard.bool(forKey: "entersReaderIfAvailable")
        } else {
            entersReaderIfAvailable = true
        }
        
        // Load backgroundEnabled
        if UserDefaults.standard.object(forKey: "backgroundEnabled") != nil {
            backgroundEnabled = UserDefaults.standard.bool(forKey: "backgroundEnabled")
        } else {
            backgroundEnabled = false
        }
        
        // Load saved color or use default
        if let savedColor = UserDefaults.standard.color(forKey: "backgroundColor") {
            backgroundColor = savedColor
        } else {
            // Set default color
            backgroundColor = .orange
            if backgroundEnabled {
                UserDefaults.standard.set(backgroundColor, forKey: "backgroundColor")
            }
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
