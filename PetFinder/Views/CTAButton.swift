//
//  CTAButton.swift
//  PetFinder
//
//  Created by Kotya on 10/06/2025.
//

import UIKit

final class CTAButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setTitle("Contact Organization", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        layer.cornerRadius = 12
        heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
