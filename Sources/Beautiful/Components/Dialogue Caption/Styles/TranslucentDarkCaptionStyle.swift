//
//  TranslucentDarkCaptionStyle.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import SwiftUI

/// A dark translucent style suitable for light or busy backgrounds.
public struct TranslucentDarkCaptionStyle: DialogueCaptionStyle {
    
    /// Creates the style.
    public init() {}
    
    /// Builds the dark overlay body.
    /// - Parameter configuration: The caption text.
    /// - Returns: Text with rounded, translucent dark background and subtle stroke/shadow.
    public func makeBody(configuration: DialogueCaptionStyleConfiguration) -> some View {
        configuration.text
            .font(.system(size: 22, weight: .regular, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .shadow(color: .white.opacity(0.08), radius: 10)
    }
}
