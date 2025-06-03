//
//  UIView+Shadow.swift
//  PetFinder
//
//  Created by Kotya on 03/06/2025.
//

import UIKit

extension UIView {
    func wrapInShadowContainer(
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.1,
        shadowRadius: CGFloat = 8,
        shadowOffset: CGSize = .zero
    ) -> UIView {
        let container = UIView()
        container.layer.shadowColor = shadowColor.cgColor
        container.layer.shadowOpacity = shadowOpacity
        container.layer.shadowRadius = shadowRadius
        container.layer.shadowOffset = shadowOffset
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
}
