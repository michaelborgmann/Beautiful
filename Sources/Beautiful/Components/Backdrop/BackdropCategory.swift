//
//  BackdropCategory.swift
//  Beautiful
//
//  Created by Michael Borgmann on 31/08/2025.
//

import Foundation

/// A category of test backdrops used by ``Backdrop``.
///
/// Each category groups one or more image asset names. These are looked up in
/// the package's resource bundle (``.module``) when the backdrop view renders.
///
/// Use this type to inject your own image sets when evaluating caption/overlay
/// styles against a variety of backgrounds.
public struct BackdropCategory {
    
    /// Display name shown in the category picker.
    public let name: String
    
    /// Image asset names belonging to this category.
    public let images: [String]
    
    /// Creates a new backdrop category.
    ///
    /// - Parameters:
    ///   - name: Display name for the category (shown in the segmented control).
    ///   - images: Image asset names in the active bundle.
    public init(name: String, images: [String]) {
        self.name = name; self.images = images
    }
}

public extension BackdropCategory {
    
    /// Built-in sample categories that ship with the package.
    ///
    /// Useful for quick demos and previews when you don't want to inject your own data.
    static var `default`: [BackdropCategory] {
        [
            BackdropCategory(name: "Bright", images: [
                "overlaytest-bright-sky",
                "overlaytest-bright-beach",
                "overlaytest-bright-snow"
            ]),
            BackdropCategory(name: "Dark", images: [
                "overlaytest-dark-stars",
                "overlaytest-dark-city",
                "overlaytest-dark-forest"
            ]),
            BackdropCategory(name: "High", images: [
                "overlaytest-busy-streetart",
                "overlaytest-busy-urban",
                "overlaytest-busy-flowers"
            ]),
            BackdropCategory(name: "Low", images: [
                "overlaytest-flat-fog",
                "overlaytest-flat-wall"
            ]),
            BackdropCategory(name: "Vibrant", images: [
                "overlaytest-vibrant-sunset",
                "overlaytest-vibrant-neon"
            ]),
            BackdropCategory(name: "Skin", images: [
                "overlaytest-faces-group",
                "overlaytest-faces-family"
            ])
        ]
    }
}
