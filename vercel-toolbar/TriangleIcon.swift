//
//  TriangleIcon.swift
//  vercel-toolbar
//
//  Created by Ryan Vogel on 8/20/25.
//

import SwiftUI

struct TriangleIcon: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Scale factor based on original SVG viewBox (76x65)
                let scaleX = width / 65
                let scaleY = height / 65
                
                // SVG path: "M37.5274 0L75.0548 65H0L37.5274 0Z"
                path.move(to: CGPoint(x: 37.5274 * scaleX, y: 0 * scaleY))
                path.addLine(to: CGPoint(x: 75.0548 * scaleX, y: 65 * scaleY))
                path.addLine(to: CGPoint(x: 0 * scaleX, y: 65 * scaleY))
                path.addLine(to: CGPoint(x: 37.5274 * scaleX, y: 0 * scaleY))
                path.closeSubpath()
            }
            .fill(Color.primary)
        }
    }
}

// Extension to create NSImage from SwiftUI view for menu bar
extension TriangleIcon {
    func createNSImage(size: CGSize = CGSize(width: 18, height: 18)) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        
        // Add padding around the triangle
        let padding: CGFloat = 3
        let triangleSize = size.width - (padding * 2)
        
        // Create the path using the exact SVG coordinates scaled to the smaller size with padding
        let path = NSBezierPath()
        let scaleX = triangleSize / 65
        let scaleY = triangleSize / 65
        
        // SVG path: "M37.5274 0L75.0548 65H0L37.5274 0Z" with padding offset
        path.move(to: CGPoint(x: padding + (37.5274 * scaleX), y: size.height - padding - (0 * scaleY))) // Flip Y for NSImage
        path.line(to: CGPoint(x: padding + (75.0548 * scaleX), y: size.height - padding - (65 * scaleY)))
        path.line(to: CGPoint(x: padding + (0 * scaleX), y: size.height - padding - (65 * scaleY)))
        path.close()
        
        NSColor.black.setFill()
        path.fill()
        
        image.unlockFocus()
        
        // Make it a template image for proper menu bar styling
        image.isTemplate = true
        
        return image
    }
}

extension NSView {
    func snapshot() -> NSImage {
        guard let bitmapRep = self.bitmapImageRepForCachingDisplay(in: self.bounds) else {
            return NSImage()
        }
        self.cacheDisplay(in: self.bounds, to: bitmapRep)
        let image = NSImage(size: self.bounds.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}

#Preview {
    TriangleIcon()
        .frame(width: 20, height: 20)
}
