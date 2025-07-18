//
//  AnimalCollectionViewCell.swift
//  PetFinder
//
//  Created by Kotya on 23/05/2025.
//

import UIKit

class AnimalCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill  
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
//        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = PropertyLabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)

            
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: photoImageView.trailingAnchor, constant: -8)
        ])
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage?) {
        photoImageView.image = image
    }
}
