//
//  PlainCaptionStyle.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import SwiftUI

/// A truly unstyled caption that relies on system defaults.
///
/// Use this to inherit the current font, color, and layout without adding any decoration.
public struct PlainCaptionStyle: DialogueCaptionStyle {
    
    /// Creates the style.
    public init() {}
    
    /// Builds the unstyled body.
    /// - Parameter configuration: The caption text.
    /// - Returns: The raw text as-is (no font/foreground/padding applied).
    public func makeBody(configuration: DialogueCaptionStyleConfiguration) -> some View {
        configuration.text
        // no font/foreground/padding -> use system defaults
    }
}
