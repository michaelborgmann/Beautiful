//
//  FlowLayout.swift
//  Beautiful
//
//  Created by Michael Borgmann on 30/11/2025.
//

import SwiftUI

/// FlowLayout arranges subviews horizontally, wrapping to a new line when
/// they exceed the available container width.
///
/// Use this layout for small items like chips, tags, or cards that need
/// to flow naturally across multiple lines.
///
/// - Parameter spacing: The horizontal and vertical spacing between items. Default is 8 points.
///
/// Example:
/// ```swift
/// FlowLayout(spacing: 10) {
///     ForEach(tags, id: \.self) { tag in
///         Text(tag)
///             .padding(8)
///             .background(.thinMaterial)
///             .cornerRadius(8)
///     }
/// }
/// ```
public struct FlowLayout: Layout {
    
    // MARK: Properties
    
    /// The horizontal and vertical spacing between items in the layout.
    public var spacing: CGFloat
    
    // MARK: - Init
    
    /// Creates a new `FlowLayout` with the specified spacing between items.
    ///
    /// - Parameter spacing: The horizontal and vertical spacing between subviews.
    ///   Defaults to `8.0` points.
    public init(spacing: CGFloat = 8.0) {
        self.spacing = spacing
    }
    
    // MARK: - Layout Protocol
    
    /// Computes and returns the size that best fits the given subviews
    /// within the proposed container size.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size for the container. If the width is
    ///     unspecified, the layout will use `.infinity` internally for calculation.
    ///   - subviews: The subviews to be laid out.
    ///   - cache: A placeholder for caching layout information. Not used
    ///     in this simple implementation.
    /// - Returns: A `CGSize` representing the total size needed to
    ///   display all subviews, respecting wrapping and spacing.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        return layout(for: subviews, in: width).size
    }
    
    /// Places subviews within the provided bounds, using the layout
    /// computed by `layout(for:in:)`.
    ///
    /// - Parameters:
    ///   - bounds: The rectangle in which to place subviews.
    ///   - proposal: The proposed size for the container (ignored here).
    ///   - subviews: The subviews to place.
    ///   - cache: A placeholder for caching layout information. Not used
    ///     in this simple implementation.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        let result = layout(for: subviews, in: bounds.width)
        
        for (index, origin) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y),
                proposal: .unspecified
            )
        }
    }
}

// MARK: - Layout Helper

extension FlowLayout {
    
    /// Computes the layout positions and total size for a given set of
    /// subviews and a container width.
    ///
    /// - Parameters:
    ///   - subviews: The subviews to arrange.
    ///   - containerWidth: The maximum width available for a single line.
    /// - Returns: A tuple containing:
    ///   - `size`: The total size needed to display all subviews.
    ///   - `positions`: An array of `CGPoint`s representing the top-left
    ///     origin of each subview.
    private func layout(for subviews: Subviews, in containerWidth: CGFloat) -> (size: CGSize, positions: [CGPoint]) {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0
        var positions: [CGPoint] = []
        
        for subview in subviews {
            
            let size = subview.sizeThatFits(.unspecified)
            let fitsInLine = (x + size.width + spacing) <= containerWidth
            
            if !fitsInLine && x > 0 {
                y += lineHeight + spacing
                x = 0
                lineHeight = 0
            }
            
            positions.append(.init(x: x, y: y))
            
            lineHeight = max(lineHeight, size.height)
            x += size.width + spacing
        }
        
        let totalHeight = y + lineHeight
        
        return (size: CGSize(width: containerWidth, height: totalHeight), positions: positions)
    }
}

// MARK: SwiftUI Previews

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
}
