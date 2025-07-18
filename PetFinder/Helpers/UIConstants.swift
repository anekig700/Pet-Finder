//
//  UIConstants.swift
//  PetFinder
//
//  Created by Kotya on 10/06/2025.
//

import Foundation
import UIKit

struct UIConstants {
    struct Padding {
        static let horizontal: CGFloat = 16
    }
    
    struct Fonts {
        static let primary: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let secondary: UIFont = .systemFont(ofSize: 14, weight: .regular)
    }
    
    struct CornerRadiuses {
        static let block: CGFloat = 16
        static let image: CGFloat = 8
    }
    
    struct Colors {
        static let mainBackground: UIColor = .tertiarySystemGroupedBackground
    }
}
