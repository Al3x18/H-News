//
//  Settings.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @Bindable var settingsViewModel: SettingsViewModel
    @Bindable var newsViewModel: NewsViewModel
    
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    var body: some View {
        List {
            Section {
                Toggle("Reader Mode", isOn: $settingsViewModel.entersReaderIfAvailable)
            } header: {
                Text("Safari View")
            } footer: {
                Text("Enable reader mode automatically when available in Safari view")
            }
            
            Section {
                Toggle("Custom Background Color", isOn: $settingsViewModel.backgroundEnabled)
                
                if settingsViewModel.backgroundEnabled {
                    ColorPicker("Background Color", selection: $settingsViewModel.backgroundColor, supportsOpacity: false)
                }
            } header: {
                Text("Appearance")
            } footer: {
                Text(
                    settingsViewModel.backgroundEnabled
                    ? "Choose the background color for the app"
                    : "Enable custom background color to change the app background"
                )
            }
            
            Section {
                Picker("Date Locale", selection: $newsViewModel.dateLocale) {
                    ForEach(DateLocale.allCases, id: \.self) { param in
                        Text(param.localeForPicker).tag(param)
                    }
                }
            } header: {
                Text("Date Preference")
            } footer: {
                Text("Choose the date style for the news")
            }
            
            Section {
                Picker("News to load", selection: $newsViewModel.loadLimit) {
                    ForEach(1...100, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
            } header: {
                Text("Load Limit")
            } footer: {
                Text("Select the number of the news to load")
            }
            
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("\(appVersion) (\(buildNumber))")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

#Preview {
    NavigationStack {
        SettingsView(settingsViewModel: SettingsViewModel(), newsViewModel: NewsViewModel())
    }
}
