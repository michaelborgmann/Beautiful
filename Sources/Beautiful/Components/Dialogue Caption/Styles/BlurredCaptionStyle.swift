//
//  BlurredCaptionStyle.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import SwiftUI

/// A blurred-backed style with subtle padding and rounding.
public struct BlurredCaptionStyle: DialogueCaptionStyle {
    
    /// Creates the style.
    public init() {}
    
    /// Builds the blurred-styled body.
    /// - Parameter configuration: The caption text.
    /// - Returns: Text with `.ultraThinMaterial` background and corner radius.
    public func makeBody(configuration: DialogueCaptionStyleConfiguration) -> some View {
        configuration.text
            .font(.title3)
            .foregroundStyle(.primary)
            .padding()
            .background(.ultraThinMaterial.opacity(0.9))
            .cornerRadius(20)
    }
}
