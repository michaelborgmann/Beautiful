//
//  DialogueCaption.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import SwiftUI

// MARK: - The View (main-actor to keep Swift 6 quiet)

/// A caption view whose **inner look** is provided by a pluggable `DialogueCaptionStyle`.
///
/// `DialogueCaption` is responsible only for **selecting** a style (from an explicit
/// one-off override or from the environment) and **passing** the text input down.
/// The style itself decides how the text is drawn.
///
/// ### Style resolution
/// 1. If created with an initializer that includes a `style:` parameter, that style is used.
/// 2. Otherwise, the style from the environment (`EnvironmentValues.dialogueCaptionStyle`) is used.
/// 3. If no style is in the environment, the default (plain) style is used.
///
/// ### Concurrency
/// The entire view is `@MainActor` to avoid Swift 6 isolation warnings when touching SwiftUI.
@MainActor
public struct DialogueCaption: View {
    
    /// The environment-provided style, if no one-off override is set.
    @Environment(\.dialogueCaptionStyle) private var envStyle
    
    /// The text content to render.
    private let text: Text
    
    /// An optional one-off style override, already type-erased.
    private let customStyle: AnyDialogueCaptionStyle?
    
    /// Creates a caption from a verbatim string (no localization).
    /// - Parameter text: A literal string used to build the text.
    public init(_ text: String) {
        self.text = Text(text)
        self.customStyle = nil
    }
    
    /// Creates a caption with a one-off style override from a string.
    /// - Parameters:
    ///   - text: A literal string used to build the text.
    ///   - style: The concrete style to apply only to this caption instance.
    public init(_ text: String, style: some DialogueCaptionStyle) {
        self.text = Text(text)
        self.customStyle = AnyDialogueCaptionStyle(style)
    }
    
    /// Resolves the style and asks it to render the caption.
    public var body: some View {
        let style = customStyle ?? envStyle
        style.makeBody(configuration: .init(text: text))
    }
}

// MARK: - SwiftUI Previews

#Preview {
    
    VStack {
        
        Spacer()
        
        DialogueCaption("The quick brown fox jumps over the lazy dog!")
            .dialogueCaptionStyle(.plain)
        
        DialogueCaption("The quick brown fox jumps over the lazy dog!")
            .dialogueCaptionStyle(.blurred)
            .multilineTextAlignment(.trailing)
            .padding(.horizontal, 24)
        
        DialogueCaption("The quick brown fox jumps over the lazy dog!")
            .dialogueCaptionStyle(.translucentDark)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.bottom, 36)
    }
    .background {
        Backdrop()
    }
}
