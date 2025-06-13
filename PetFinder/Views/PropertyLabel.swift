//
//  PropertyLabel.swift
//  PetFinder
//
//  Created by Kotya on 13/06/2025.
//

import UIKit

final class PropertyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        font = .systemFont(ofSize: 12, weight: .regular)
        textColor = .black
        backgroundColor = .systemGray5
        layer.cornerRadius = 4
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
