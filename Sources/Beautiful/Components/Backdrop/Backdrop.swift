//
//  Backdrop.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import SwiftUI

/// A developer utility view that renders a full-screen background image chosen
/// from one or more ``BackdropCategory`` lists, with optional pickers to switch
/// the active category and image.
///
/// This component is intended for **internal demos and testing** of overlay
/// styles (e.g. dialogue captions) against different kinds of imagery. It is
/// not meant to be part of your production UI unless you deliberately expose it.
///
/// The view is self-contained:
/// - If you pass an empty category list, it will fall back to a single “Empty” category.
/// - The initially selected category and image indices are **clamped** into valid ranges.
/// - When the category changes, the selected image index resets to `0`.
public struct Backdrop: View {
    
    /// Whether the control panel (pickers) is visible.
    public let showPickers: Bool
    
    /// The list of categories from which the background images are drawn.
    public let backdrops: [BackdropCategory]
    
    /// The zero-based index of the currently selected category in ``backdrops``.
    @State private var selectedBackdropCategory: Int
    
    /// The zero-based index of the currently selected image inside the active backdrop category.
    @State private var selectedBackdropImage: Int
    
    /// Creates a new backdrop gallery.
    ///
    /// - Parameters:
    ///   - showPickers: Controls visibility of the pickers. Defaults to `true`.
    ///   - backdrops: The categories to use. Defaults to ``BackdropCategory/default``.
    ///                If the array is empty, the view substitutes an “Empty” category.
    ///   - defaultCategory: Zero-based index of the initially selected category.
    ///                      Values are clamped into range.
    ///   - defaultImage: Zero-based index of the initially selected image within
    ///                   the chosen category. Values are clamped into range.
    ///
    /// ### Example
    /// ```swift
    /// Backdrop(
    ///   showPickers: true,
    ///   backdrops: BackdropCategory.default,
    ///   defaultCategory: 1,   // "Dark"
    ///   defaultImage: 2       // 3rd image in "Dark"
    /// )
    /// ```
    public init(
            showPickers: Bool = true,
            backdrops: [BackdropCategory] = BackdropCategory.default,
            defaultCategory: Int = 0,
            defaultImage: Int = 0
    ) {
        self.showPickers = showPickers
        
        // Ensure we have at least one category
        self.backdrops = backdrops.isEmpty ? [.init(name: "Empty", images: [])] : backdrops

        // Clamp category
        let safeCategory = max(0, min(defaultCategory, self.backdrops.count - 1))

        // Clamp image (also safe if the chosen category has 0 images)
        let imageCount = self.backdrops[safeCategory].images.count
        let safeImage = max(0, min(defaultImage, max(imageCount - 1, 0)))

        // Initialize @State properly
        _selectedBackdropCategory = State(initialValue: safeCategory)
        _selectedBackdropImage    = State(initialValue: safeImage)
    }
    
    /// The root view hierarchy for the backdrop gallery.
    public var body: some View {
        
        VStack {
            
            if showPickers {
                VStack {
                    Picker("Backdrop Category", selection: $selectedBackdropCategory) {
                        ForEach(0..<backdrops.count, id: \.self) { index in
                            Text(backdrops[index].name).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Backdrop Image",selection: $selectedBackdropImage) {
                        ForEach(0..<backdrops[selectedBackdropCategory].images.count, id: \.self) {index in
                            Text(backdrops[selectedBackdropCategory].images[index]).tag(index)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding()
                
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: selectedBackdropCategory) {
            _ in selectedBackdropImage = 0
        }
        .background {
            Image(backdrops[selectedBackdropCategory].images[selectedBackdropImage], bundle: .module)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .animation(.easeInOut, value: selectedBackdropImage)
        }
    }
}

// MARK: - SwiftUI Previews

#Preview {
    Backdrop(showPickers: true, backdrops: BackdropCategory.default, defaultCategory: 0, defaultImage: 0)
}
