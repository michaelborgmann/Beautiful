//
//  StyleTokens.swift.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import Foundation

// MARK: - Shorthand tokens (typed)

public extension DialogueCaptionStyle where Self == PlainCaptionStyle {
    
    /// Shorthand token for `PlainCaptionStyle()`.
    static var plain: Self { .init() }
}

public extension DialogueCaptionStyle where Self == BlurredCaptionStyle {
    
    /// Shorthand token for `BlurredCaptionStyle()`.
    static var blurred: Self { .init() }
}

public extension DialogueCaptionStyle where Self == TranslucentDarkCaptionStyle {
    
    /// Shorthand token for `TranslucentDarkCaptionStyle()`.
    static var translucentDark: Self { .init() }
}
