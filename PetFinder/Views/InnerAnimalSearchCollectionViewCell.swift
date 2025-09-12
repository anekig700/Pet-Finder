//
//  InnerAnimalSearchCollectionViewCell.swift
//  PetFinder
//
//  Created by Kotya on 05/09/2025.
//

import UIKit

class InnerAnimalSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "InnerAnimalSearchCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemBlue : .clear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Type) {
        label.text = model.name
    }
}
