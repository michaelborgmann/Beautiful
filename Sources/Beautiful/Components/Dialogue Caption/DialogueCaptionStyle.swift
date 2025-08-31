//
//  DialogueCaptionStyle.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import SwiftUI

// MARK: - Style Protocol (UI-only work lives on main actor)

/// A style that renders the inner look of a `DialogueCaption`.
///
/// Styles are **UI-only** and therefore constrained to the main actor.
/// Each conforming style returns any SwiftUI `View` via an opaque `some View`
/// (expressed here using an associated type for better type-checking).
///
/// The common pattern is to inspect the provided configuration and build a view.
///
/// ```swift
/// struct BlurredCaptionStyle: DialogueCaptionStyle {
///     func makeBody(configuration: DialogueCaptionStyleConfiguration) -> some View {
///         configuration.text
///             .padding()
///             .background(.ultraThinMaterial)
///             .cornerRadius(20)
///     }
/// }
/// ```
@MainActor
public protocol DialogueCaptionStyle {
    
    /// The concrete view type produced by the style.
    associatedtype Body: View
    
    /// Builds the styled body for a given configuration.
    ///
    /// - Parameter configuration: Inputs needed by the style (e.g., caption text).
    /// - Returns: A view that draws the caption according to this style.
    func makeBody(configuration: DialogueCaptionStyleConfiguration) -> Body
}

/// Inputs passed to a `DialogueCaptionStyle`.
///
/// Currently contains only the caption `Text`, but this struct can grow over time
/// (e.g., to include layout hints) without breaking existing styles.
///
/// The configuration is marked `@MainActor` because it is consumed by UI-only styles.
@MainActor
public struct DialogueCaptionStyleConfiguration {
    
    /// The caption text to render.
    public let text: Text
    
    /// Creates a configuration.
    /// - Parameter text: The caption text to render.
    public init(text: Text) { self.text = text }
}
