//
//  News.swift
//  HNews
//
//  Created by Alex De Pasquale on 25/01/26.
//

import SwiftUI

struct News: View {
    @Environment(\.openURL) var openURL
    
    @Bindable var viewModel: NewsViewModel
    @Binding var selectedURLItem: URLItem?
    
    @State private var showNoURLError = false
    
    let accentColor: Color
    
    var body: some View {
        List(viewModel.stories) { news in
            NewsCard(news: news, viewModel: viewModel, accentColor: accentColor) {
                print("DEBUG, tap on url: \(news.url ?? "NO_URL")")
                if let urlString = news.url, let url = URL(string: urlString) {
                    selectedURLItem = URLItem(url: url)
                } else {
                    showNoURLError = true
                }
            }
            .contextMenu {
                Button("Open in Browser", systemImage: "square.and.arrow.up") {
                    if let urlString = news.url, let url = URL(string: urlString) {
                        openURL(url)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)
        }
        .alert("No URL Available", isPresented: $showNoURLError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This news doesn't have a URL available.")
        }
    }
}

// MARK: - News Card
struct NewsCard: View {
    let news: Story
    let viewModel: NewsViewModel
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                // Header with time and type badge
                HStack(alignment: .top) {
                    if let time = news.time {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.caption2)
                            Text(viewModel.formattedDate(from: time))
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    // Type badge
                    Text(news.type.uppercased())
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(accentColor.opacity(0.8).contrastingTextColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(accentColor.opacity(0.8))
                        )
                }
                
                // Title
                Text(news.title)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .foregroundStyle(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Author info
                HStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(news.by)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right.square.fill")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.primary.opacity(0.1), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .contentShape(Rectangle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Color Extension for Contrasting Text
extension Color {
    var contrastingTextColor: Color {
        let uiColor = UIColor(self)
        
        // Convert to RGB color space
        guard let rgbColor = uiColor.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
              let components = rgbColor.components,
              components.count >= 3 else {
            // Fallback: assume dark background, use white text
            return .white
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        
        // Calculate relative luminance using the formula from WCAG
        // L = 0.2126 * R + 0.7152 * G + 0.0722 * B
        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        
        // If luminance is greater than 0.5, the color is light, use black text
        // Otherwise, use white text
        return luminance > 0.5 ? .black : .white
    }
}
