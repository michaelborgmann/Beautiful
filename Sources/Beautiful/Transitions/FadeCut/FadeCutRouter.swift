//
//  FadeCutRouter.swift
//  Beautiful
//
//  Created by Michael Borgmann on 29/01/2026.
//

import SwiftUI

/// A lightweight view router that performs a *hard screen cut*
/// masked by a full-screen fade.
///
/// `FadeCutRouter` fades the current screen to an opaque veil,
/// swaps the destination view *without animation*, and fades
/// the veil away again. This avoids crossfades or layout
/// interpolation between unrelated screens.
///
/// This is useful for cinematic transitions such as:
/// - onboarding flows
/// - story or scene changes
/// - modal-like overlays without navigation stacks
///
/// ## Example
/// ```swift
/// FadeCutRouter { go in
///     RootView(onBegin: { go(.overlay) })
/// } overlay: { go in
///     OverlayView(onBack: { go(.root) })
/// }
/// ```
public struct FadeCutRouter<Root: View, Overlay: View>: View {

    /// The available router destinations.
    public enum Screen {
        
        /// The primary/root screen.
        case root
        
        /// The secondary/overlay screen.
        case overlay
    }
    
    // MARK: - State
    
    /// The currently visible screen.
    @State private var screen: Screen = .root
    
    /// The opacity of the full-screen transition veil.
    @State private var veilOpacity: CGFloat = 0
    
    /// Indicates whether a transition is currently in progress.
    @State private var isTransitioning = false
    
    /// The currently active transition task.
    @State private var transitionTask: Task<Void, Never>? = nil

    // MARK: - Configuration

    /// The duration (in seconds) of a single fade phase.
    private let fadeDuration: Double
    
    /// The color of the full-screen transition veil.
    private let veilColor: Color

    // MARK: - Screen Builders
    
    /// Builder for the root screen.
    private let root: (_ go: @escaping (Screen) -> Void) -> Root
    
    /// Builder for the overlay screen.
    private let overlay: (_ go: @escaping (Screen) -> Void) -> Overlay
    
    // MARK: - Initialization
    
    /// Creates a new fade-cut router.
    ///
    /// - Parameters:
    ///   - fadeDuration: The duration (in seconds) of each fade phase.
    ///   - veilColor: The color of the transition veil.
    ///   - root: A builder for the root screen.
    ///   - overlay: A builder for the overlay screen.
    public init(
        fadeDuration: Double = 0.8,
        veilColor: Color = .black,
        @ViewBuilder root: @escaping (_ go: @escaping (Screen) -> Void) -> Root,
        @ViewBuilder overlay: @escaping (_ go: @escaping (Screen) -> Void) -> Overlay
    ) {
        self.fadeDuration = fadeDuration
        self.veilColor = veilColor
        self.root = root
        self.overlay = overlay
    }
    
    // MARK: - View
    
    public var body: some View {
        ZStack {
            Group {
                switch screen {
                case .root:
                    root { transition(to: $0) }
                case .overlay:
                    overlay { transition(to: $0) }
                }
            }
            .transaction { $0.animation = nil }

            veilColor
                .ignoresSafeArea()
                .opacity(veilOpacity)
                .allowsHitTesting(isTransitioning || veilOpacity > 0.01)
        }
        .onDisappear {
            transitionTask?.cancel()
            transitionTask = nil
        }
    }
    
    // MARK: - Transition Logic
    
    /// Performs a fade-cut transition to the given screen.
    ///
    /// If a transition is already in progress, or if the
    /// destination screen is already active, this method
    /// does nothing.
    ///
    /// Transition steps:
    /// 1. Fade the veil to fully opaque.
    /// 2. Swap the active screen without animation.
    /// 3. Fade the veil back to transparent.
    ///
    /// - Parameter next: The destination screen.
    private func transition(to next: Screen) {
        guard !isTransitioning, next != screen else { return }

        transitionTask?.cancel()

        isTransitioning = true

        transitionTask = Task { @MainActor in
            defer { isTransitioning = false }

            // Fade to black
            withAnimation(.easeInOut(duration: fadeDuration)) {
                veilOpacity = 1
            }

            // Wait approximately for the fade to complete
            try? await Task.sleep(nanoseconds: UInt64(fadeDuration * 1_000_000_000))

            // Hard swap with no animation
            var tx = Transaction()
            tx.animation = nil
            withTransaction(tx) { screen = next }

            // Fade back in
            withAnimation(.easeInOut(duration: fadeDuration)) {
                veilOpacity = 0
            }

            try? await Task.sleep(nanoseconds: UInt64(fadeDuration * 1_000_000_000))

            transitionTask = nil
        }
    }
}

// MARK: - Convenience Initializer Extension

/// A convenience initializer that preserves type inference at the call site
/// by erasing the concrete screen view types.
///
/// SwiftUI view builders often produce deeply nested, anonymous generic types.
/// Exposing those types through `FadeCutRouter<Root, Overlay>` can make
/// the call site verbose or difficult for the compiler to infer.
///
/// This extension constrains `Root` and `Overlay` to `AnyView`, allowing
/// consumers to:
/// - avoid explicit generic parameters
/// - simplify complex view hierarchies
/// - reduce compile-time type complexity
///
/// ### Why this must exist
/// Without this extension, the following would either fail to compile
/// or require explicit generic annotations:
///
/// ```swift
/// FadeCutRouter { go in
///     SomeComplexView { go(.overlay) }
/// } overlay: { go in
///     AnotherDeeplyNestedView { go(.root) }
/// }
/// ```
///
/// By type-erasing the root and overlay views internally, this initializer
/// provides a cleaner API surface while keeping the strongly typed
/// generic version available for performance-critical or internal use.
///
/// This mirrors patterns used internally by SwiftUI, such as `AnyView`,
/// `NavigationLink`, and `ViewBuilder`-based initializers.
public extension FadeCutRouter where Root == AnyView, Overlay == AnyView {
    init(
        fadeDuration: Double = 0.8,
        veilColor: Color = .black,
        @ViewBuilder root: @escaping (_ go: @escaping (Screen) -> Void) -> some View,
        @ViewBuilder overlay: @escaping (_ go: @escaping (Screen) -> Void) -> some View
    ) {
        self.init(
            fadeDuration: fadeDuration,
            veilColor: veilColor,
            root: { go in AnyView(root(go)) },
            overlay: { go in AnyView(overlay(go)) }
        )
    }
}

// MARK: - Previews

#Preview("Buttons") {
    FadeCutRouter { go in
        Button("Start") { go(.overlay) }
            .padding()
    } overlay: { go in
        VStack(spacing: 16) {
            Text("Overlay")
            Button("Back") { go(.root) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

#Preview {
    FadeCutRouter { _ in
        Color.blue
    } overlay: { _ in
        Color.red
    }
}
