//
//  FontManager.swift
//  vercel-toolbar
//
//  Created by Ryan Vogel on 8/20/25.
//

import SwiftUI

extension Font {
    static func geist(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        // First try to use Geist if installed, fallback to system font with similar characteristics
        return Font.custom("Geist", size: systemSize(for: style))
            .weight(weight)
    }
    
    static func geistMono(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Geist Mono", size: systemSize(for: style))
            .weight(weight)
    }
    
    private static func systemSize(for style: Font.TextStyle) -> CGFloat {
        switch style {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .body: return 17
        case .callout: return 16
        case .subheadline: return 15
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 17
        }
    }
}