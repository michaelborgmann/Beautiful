//
//  FeatureCard.swift
//  Beautiful
//
//  Created by Michael Borgmann on 02/08/2025.
//

import SwiftUI

/// A visual feature card for highlighting creative tools, stories, or content areas in your app.
///
/// `FeatureCard` blends background imagery, a title, and an optional subtitle
/// into a stylized, tappable card. It supports dynamic sizing and Apple-like
/// materials for polished presentation.
///
/// Example:
///
/// ```swift
/// FeatureCard(
///     title: "World Builder",
///     subtitle: "Create magical settings for your stories",
///     image: Image("storymaker_worlds"),
///     backgroundColor: .blue,
///     foregroundColor: .white,
///     height: 200
/// ) {
///     launchWorldBuilder()
/// }
/// ```
public struct FeatureCard: View {

    // MARK: - Properties

    /// The main title displayed in the bottom overlay.
    public let title: String
    
    /// An optional subtitle shown below the title.
    public let subtitle: String?
    
    /// An optional background image behind the foreground overlay.
    public let image: Image?
    
    /// The background color, used beneath or blended with the image.
    public let backgroundColor: Color
    
    /// The foreground color for text and overlay content.
    public let foregroundColor: Color
    
    /// An optional fixed height for the card.
    public let height: CGFloat?
    
    /// The action triggered when the card is tapped.
    public let action: () -> Void

    // MARK: - Init

    /// Creates a new `FeatureCard` with optional background, styling, and tap action.
    ///
    /// - Parameters:
    ///   - title: The main heading of the card.
    ///   - subtitle: A secondary line of text, shown below the title.
    ///   - image: An optional image layered behind the content.
    ///   - backgroundColor: The background color of the card.
    ///   - foregroundColor: The color used for text.
    ///   - height: An optional fixed height; the card stretches by default.
    ///   - action: The closure triggered when the card is tapped.
    public init(
        title: String,
        subtitle: String? = nil,
        image: Image? = nil,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        height: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.height = height
        self.action = action
    }

    // MARK: - View Body

    /// The visual representation of the feature card.
    public var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.2)) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                action()
            }
        }) {
            ZStack(alignment: .bottomLeading) {
                backgroundLayer
                foregroundContent
            }
            .frame(height: height)
            .frame(minHeight: 80)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
            .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: -2)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Layers

    /// The background layer with optional image and color blending.
    private var backgroundLayer: some View {
        backgroundColor
            .overlay(
                image?
                    .resizable()
                    .scaledToFill()
                    .clipped()
            )
    }
    
    /// The foreground overlay with title and subtitle.
    private var foregroundContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(foregroundColor)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(foregroundColor.opacity(0.85))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: .black.opacity(0.3), location: 0.6),
                            Gradient.Stop(color: .clear, location: 1.0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: .black.opacity(0), location: 0),
                            Gradient.Stop(color: .black, location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
    }
}

// MARK: SwiftUI Previews

#Preview {
    
    FeatureCard(
        title: "Feature Card",
        subtitle: "Highlight a creative tool with image, title, and action.",
        image: Image("landscape", bundle: .module),
        backgroundColor: .blue,
        foregroundColor: .white,
        action: {}
    )
}
