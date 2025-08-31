//
//  AnyDialogueCaptionStyle.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import SwiftUI

// MARK: - Type erasure for Environment storage (Swift 6 safe)


/// A type-erased wrapper for any `DialogueCaptionStyle`.
///
/// SwiftUI's `Environment` requires concrete, single types. Because each style
/// can return a different concrete `View` type from `makeBody`, we **erase** that
/// type to `AnyView` and store a single renderer closure.
///
/// ### Concurrency note
/// The stored renderer runs on the **main actor**. The wrapper’s designated initializer
/// is **nonisolated**, but it accepts a closure that *is* `@MainActor`. This lets us
/// construct the wrapper in nonisolated contexts (like an `EnvironmentKey.defaultValue`)
/// while deferring the main-actor work until SwiftUI renders the view.
public struct AnyDialogueCaptionStyle {
    
    /// The type-erased render function.
    ///
    /// - Important: This closure itself is isolated to the **main actor** because it
    ///   touches SwiftUI views. That satisfies Swift 6’s actor isolation without
    ///   forcing the wrapper to be `@MainActor`.
    private let _makeBody: @MainActor (DialogueCaptionStyleConfiguration) -> AnyView
    
    /// Creates a type-erased style from a main-actor renderer.
    ///
    /// Use this initializer when you already have a render closure that returns an `AnyView`.
    ///
    /// - Parameter makeBody: A main-actor closure that renders a configuration to `AnyView`.
    public init(_ makeBody: @escaping @MainActor (DialogueCaptionStyleConfiguration) -> AnyView) {
        self._makeBody = makeBody
    }
    
    /// Creates a type-erased style from a concrete `DialogueCaptionStyle`.
    ///
    /// This convenience initializer runs on the **main actor** because it calls the style’s
    /// `makeBody`. It converts the `some View` result into `AnyView` for storage.
    ///
    /// - Parameter style: A concrete caption style to wrap.
    @MainActor
    public init<S: DialogueCaptionStyle>(_ style: S) {
        self._makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }
    
    /// Renders the style for a given configuration.
    ///
    /// This method is `@MainActor` because it ultimately builds SwiftUI views.
    /// It returns `some View` for ergonomic use at call sites, but internally the
    /// renderer produces an `AnyView` to keep the environment-transportable erased form.
    ///
    /// - Parameter configuration: The inputs for rendering.
    /// - Returns: The styled caption view.
    @MainActor @ViewBuilder
    public func makeBody(configuration: DialogueCaptionStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - Environment

/// Environment key for the current `DialogueCaption` style.
private struct DialogueCaptionStyleKey: EnvironmentKey {
    
    /// The default style used when no style is injected into the environment.
    ///
    /// We construct the `AnyDialogueCaptionStyle` using the **closure-based initializer**.
    /// This avoids calling a `@MainActor` initializer from a nonisolated context
    /// (which `EnvironmentKey.defaultValue` is), satisfying Swift 6’s rules.
    static var defaultValue: AnyDialogueCaptionStyle {
        AnyDialogueCaptionStyle { config in
            AnyView(PlainCaptionStyle().makeBody(configuration: config))
        }
    }
}

public extension EnvironmentValues {
    
    /// The environment-provided style used by `DialogueCaption` when no local override is set.
    var dialogueCaptionStyle: AnyDialogueCaptionStyle {
        get { self[DialogueCaptionStyleKey.self] }
        set { self[DialogueCaptionStyleKey.self] = newValue }
    }
}

// MARK: - View + Modifier

public extension View {
    
    /// Sets the `DialogueCaption` style within this view's environment.
    ///
    /// - Parameter style: A concrete `DialogueCaptionStyle` to apply.
    /// - Returns: A view with the style applied to all descendant `DialogueCaption`s.
    func dialogueCaptionStyle(_ style: some DialogueCaptionStyle) -> some View {
        environment(\.dialogueCaptionStyle, AnyDialogueCaptionStyle(style))
    }
}
