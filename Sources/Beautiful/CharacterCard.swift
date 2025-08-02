//
//  CharacterCard.swift
//  Beautiful
//
//  Created by Michael Borgmann on 10/07/2025.
//

import SwiftUI

/// A visual character card for displaying a selected emoji or image,
/// commonly used in character selection or creation screens.
///
/// `CharacterCard` is flexible and can adapt to various layouts and visual inputs.
/// You can use it with `.emoji`, `.image`, or pass `nil` to show a placeholder.
///
/// Example:
///
/// ```swift
/// CharacterCard(
///     visual: .emoji("🧚‍♀️"),
///     background: .white,
///     aspectRatio: 1,
///     cornerRadius: 24,
///     shadowRadius: 3
/// )
/// ```
public struct CharacterCard: View {
    
    // MARK: Enums
    
    /// Represents the visual content of a character.
    public enum CharacterVisual: Equatable {
        
        /// An emoji-based character.
        case emoji(String)
        
        /// An image-based character.
        case image(Image)
    }
    
    // MARK: - Properties
    
    /// The character's visual representation.
    let visual: CharacterVisual?
    
    /// The placeholder emoji shown when `visual` is `nil`.
    let placeholder: String
    
    /// The background color of the card.
    let background: Color
    
    /// The card’s width-to-height ratio.
    let aspectRatio: CGFloat // e.g., 1.0 for square, 4/3 for 4:3
    
    /// The corner radius of the card’s rounded background.
    let cornerRadius: CGFloat
    
    /// The shadow radius for the card’s background.
    let shadowRadius: CGFloat
    
    // MARK: - Init

    /// Creates a new `CharacterCard` with optional visual content and styling.
    ///
    /// - Parameters:
    ///   - visual: The emoji or image to show in the card.
    ///   - placeholder: The fallback emoji if no visual is provided.
    ///   - background: The background color of the card.
    ///   - aspectRatio: The width-to-height ratio (e.g., 1.0 for square).
    ///   - cornerRadius: The corner radius of the card.
    ///   - shadowRadius: The shadow radius.
    public init(
        visual: CharacterVisual?,
        placeholder: String = "👤",
        background: Color = .white,
        aspectRatio: CGFloat = 1.0,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 4,
    ) {
        self.visual = visual
        self.placeholder = placeholder
        self.background = background
        self.aspectRatio = aspectRatio
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    // MARK: - View
    
    /// The body of the card view.
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(background)
                .shadow(radius: shadowRadius)
            
            visualView()
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }
    
    // MARK: - Subviews
    
    /// Renders the visual content (emoji, image, or placeholder) sized to the card.
    @ViewBuilder
    private func visualView() -> some View {
        GeometryReader { geo in
            switch visual {
            case .emoji(let emoji):
                Text(emoji)
                    .font(.system(size: geo.size.width * 0.8))
                    .frame(width: geo.size.width, height: geo.size.height)
                    .foregroundColor(.primary)
            case .image(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .none:
                Text(placeholder)
                    .font(.system(size: geo.size.width * 0.3))
                    .frame(width: geo.size.width, height: geo.size.height)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - SwiftUI Previews

#Preview {
    CharacterCard(
        visual: .emoji("🦧"),
        placeholder: "👤",
        background: .white,
        aspectRatio: 1,
        cornerRadius: 24,
        shadowRadius: 3,
    )
}
