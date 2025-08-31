//
//  Pressable.swift
//  Beautiful
//
//  Created by Michael Borgmann on 10/07/2025.
//

import SwiftUI

/// A reusable interaction wrapper that adds press feedback (scale + tap)
/// to any view content.
///
/// `Pressable` mimics native button behavior:
/// - Animates down on touch
/// - Cancels on drag out
/// - Triggers an action on release inside bounds
///
/// You can use it directly:
///
/// ```swift
/// Pressable(action: {
///     print("Tapped!")
/// }) {
///     Text("Tap me")
/// }
/// ```
///
/// Or with the `.pressable` modifier:
///
/// ```swift
/// Image(systemName: "heart")
///     .pressable {
///         markAsFavorite()
///     }
/// ```
public struct Pressable<Content: View>: View {
    
    // MARK: - Properties
    
    /// The action to run when the press is released inside the bounds.
    private let action: () -> Void
    
    /// The content to display inside the pressable view.
    private let content: () -> Content
    
    /// Tracks whether the view is visually "pressed in" for animation.
    @State private var isPressed = false
    
    /// Tracks the current touch location for validating press boundaries.
    @GestureState private var dragLocation: CGPoint? = nil
    
    @State private var frame: CGRect = .zero
    
    // MARK: - Init
    
    /// Creates a pressable view that wraps any content.
    ///
    /// - Parameters:
    ///   - action: The action to perform on valid press release.
    ///   - content: The content to render inside the wrapper.
    public init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    // MARK: - View
    
    /// The view body that handles gestures and animations.
    @ViewBuilder
    public var body: some View {
        content()
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .contentShape(Rectangle())
            .overlay(
                GeometryReader { geometry in
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .updating($dragLocation) { value, state, _ in
                                    state = value.location
                                }
                                .onChanged { value in
                                    let frame = geometry.frame(in: .global)
                                    isPressed = frame.contains(value.location)
                                }
                                .onEnded { value in
                                    let frame = geometry.frame(in: .global)
                                    isPressed = false
                                    if frame.contains(value.location) {
                                        action()
                                    }
                                }
                        )
                }
            )
    }
}

// MARK: - Modifier

/// Applies `Pressable` behavior to any view.
///
/// Adds tactile feedback via a press gesture with bounce animation.
///
/// - Parameter action: The action to run when released inside the view.
extension View {
    
    /// Applies `Pressable` behavior to any view.
    ///
    /// Adds tactile feedback via a press gesture with bounce animation,
    /// and triggers an action on valid release.
    ///
    /// - Parameter action: The action to run when released inside the view bounds.
    /// - Returns: A modified view that responds to press gestures.
    public func pressable(action: @escaping () -> Void) -> some View {
        Pressable(action: action) { self }
    }
}

#Preview {
    Pressable<CharacterCard>(
        action: {},
        content: { CharacterCard( visual: .emoji("🦧")) }
    )
}
