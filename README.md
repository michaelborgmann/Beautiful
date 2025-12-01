# 🌈 Beautiful

![Swift](https://img.shields.io/badge/Swift-5.10%20%7C%206.0-orange.svg?logo=swift)
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
- `DialogueCaption` – beautiful, stylable captions for dialogue and narration
- `Pressable` – a flexible gesture wrapper for native-feeling press feedback
- `.pressable()` – a SwiftUI modifier to apply press behavior to any view
- `Backdrop` *(dev utility)* – switch among categorized background images to **test overlays/captions** against different scenes
* `FlowLayout` – a lightweight, horizontal flow layout with wrapping support for dynamic content like tags, chips, or small cards

---

## 📦 Installation

Add **Beautiful** via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/michaelborgmann/Beautiful.git", from: "0.4.0")
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

### 🖼️ Backdrop (dev utility)

A full-screen, developer-only view for evaluating overlay/caption styles on top of different kinds of imagery. Not intended for production UI unless you deliberately expose it.

**Quick start**
```swift
Backdrop() // uses built-in sample categories & shows pickers
```

**Inject your own backdrops**

```swift
let customBackdrops: [BackdropCategory] = [
    .init(name: "Brand",  images: ["brand-gradient-1","brand-gradient-2"]),
    .init(name: "Photos", images: ["hero-1","hero-2","hero-3"])
]

Backdrop(showPickers: true,
         backdrops: customBackdrops,
         defaultCategory: 0,
         defaultImage: 0)
```

**Hide controls (great for screenshots)**

```swift
Backdrop(showPickers: false,
         backdrops: customBackdrops,
         defaultCategory: 1,   // start on “Photos”
         defaultImage: 2)      // 3rd image in that category
```

**API**

* `Backdrop(showPickers: Bool = true,
            backdrops: [BackdropCategory] = .default,
            defaultCategory: Int = 0,
            defaultImage: Int = 0)`

* `BackdropCategory(name: String, images: [String])`

* `BackdropCategory.default` — built-in sample sets you can use immediately

---

### 💬 DialogueCaption

A flexible caption component for dialogue or narration text.
Supports multiple built-in styles and custom styling via `DialogueCaptionStyle`.

```swift
DialogueCaption("The quick brown fox jumps over the lazy dog!")
    .dialogueCaptionStyle(.translucentDark)
    .multilineTextAlignment(.center)
    .padding(.horizontal, 16)
    .padding(.bottom, 36)
```

#### Built-in styles

* `.plain` – raw text, inherits system defaults
* `.blurred` – soft, blurred background with padding
* `.translucentDark` *(default)* – edge-to-edge, rounded dark overlay

```swift
VStack(spacing: 20) {
    DialogueCaption("Plain Caption")
        .dialogueCaptionStyle(.plain)

    DialogueCaption("Blurred Caption")
        .dialogueCaptionStyle(.blurred)

    DialogueCaption("Dark Caption")
        .dialogueCaptionStyle(.translucentDark)
}
```

#### Custom styles

Create your own styles by conforming to `DialogueCaptionStyle`:

```swift
struct MyCustomStyle: DialogueCaptionStyle {
    func makeBody(configuration: DialogueCaptionStyleConfiguration) -> some View {
        configuration.text
            .font(.title3)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
    }
}

DialogueCaption("Custom caption!")
    .dialogueCaptionStyle(MyCustomStyle())
```

---

### 🖇 FlowLayout

A simple layout that arranges subviews **horizontally** and wraps them onto new lines when they exceed the container width. Ideal for **tags, chips, or small dynamic items**.

```swift
FlowLayout(spacing: 8) {
    ForEach(tags, id: \.self) { tag in
        Text(tag)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
            .foregroundColor(.white)
            .font(.caption)
    }
}
.frame(maxWidth: .infinity, alignment: .leading)
.padding()
```

**Preview example:**

```swift
#Preview {
    let tags = ["Beautiful", "FlowLayout", "Demo", "Short", "Medium-length", "A very, very long tag", "⚡️"]

    FlowLayout(spacing: 8) {
        ForEach(tags, id: \.self) { tag in
            Text(tag)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .previewLayout(.sizeThatFits)
}
```

---

## 🧪 Requirements

- **Xcode 15.3+** (Swift **5.10** or newer)
- **iOS 17+**  
  _(also supports macOS 14+, tvOS 17+, watchOS 10+)_
- **Swift Package Manager**

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
