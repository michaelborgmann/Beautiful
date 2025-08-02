# 🌈 Beautiful

![Swift](https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange.svg?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17%2B-blue.svg?logo=apple)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen?logo=swift)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
![Version](https://img.shields.io/github/v/tag/michaelborgmann/Beautiful?label=release)

Beautiful is a collection of carefully crafted, reusable SwiftUI components focused on **delightful interactions** and **clean visual presentation** — built with kids, creatives, and story-first apps in mind.

Designed to be portable, expressive, and lightweight.

---

## ✨ Features

- `FeatureCard` – a flexible card layout with background imagery, color theming, and title/subtitle support
- `CharacterCard` – a visual representation for emoji or image-based characters
- `Pressable` – a flexible gesture wrapper for native-feeling press feedback
- `.pressable()` – a SwiftUI modifier to apply press behavior to any view

---

## 📦 Installation

Add **Beautiful** via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/michaelborgmann/Beautiful.git", from: "0.2.0")
]
```

Or in Xcode:

- File → Add Packages
- Enter the repo URL
- Choose Beautiful

---

## 🚀 Components

### 🧸 CharacterCard

```swift
CharacterCard(
    visual: .emoji("🦄"),
    placeholder: "👤",
    background: .white,
    aspectRatio: 1,
    cornerRadius: 24,
    shadowRadius: 3,
    padding: 16
)
```

Supports:

- Emoji or image visual
- Custom aspect ratios (square, 4:3, etc.)
- Rounded corners and shadows
- Placeholder fallback

---

### 👆 Pressable & .pressable()

```swift
Pressable(action: {
    print("Tapped!")
}) {
    CharacterCard(visual: .emoji("🦊"))
}
```

Or:

```swift
Text("Tap Me")
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .pressable {
        print("Tapped!")
    }
```

Adds smooth press animation and native-like release behavior.

---

### 🗂 FeatureCard

```swift
FeatureCard(
    title: "World Builder",
    subtitle: "Design your own magical realm",
    image: Image("storymaker_worlds"),
    backgroundColor: .blue,
    foregroundColor: .white
) {
    print("Tapped!")
}
```

Supports:

- Optional background image and color layer
- Rounded corners, shadows, and material overlays
- Configurable height and theme colors
- Built-in tap gesture with haptic feedback

---

## 🧪 Requirements

- Swift 5.10+
- iOS 17+
- SwiftUI

---

## 🗺️ Roadmap

- Add .selected overlay support for CharacterCard
- Optional haptic feedback for Pressable
- Expand visuals (e.g. imageURL, SF Symbols)
- Add web/Android equivalents later via portable design system

---

## 👤 About

Created with care by [Michael Borgmann](https://github.com/michaelborgmann) for joyful, expressive apps — like WonderTales.

---

📄 License

MIT License. See LICENSE for details.
