//
//  AnimalTableViewCell.swift
//  PetFinder
//
//  Created by Kotya on 20/04/2025.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {
    
    private var currentImagePath: String?
    private let containerView = UIView()
    
    let imageLoader = ImageLoader()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
     }()
    
    let animalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 266).isActive = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.primary
        label.textColor = .black
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .secondaryLabel
        label.text = "Age"
        return label
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .secondaryLabel
        label.text = "Gender"
        return label
    }()
    
    let breedLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.secondary
        label.textColor = .secondaryLabel
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .secondaryLabel
        label.text = "Weight"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let horizontalStackView = UIStackView(arrangedSubviews: [
            ageLabel,
            genderLabel,
            weightLabel
        ])
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 5
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            nameLabel,
            breedLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
//        verticalStackView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        let wrapperVerticalStackView = UIView()
        wrapperVerticalStackView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.bottomAnchor.constraint(equalTo: wrapperVerticalStackView.bottomAnchor, constant: -8),
            verticalStackView.leadingAnchor.constraint(equalTo: wrapperVerticalStackView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            verticalStackView.trailingAnchor.constraint(equalTo: wrapperVerticalStackView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
        ])
    
        
        let mainStackView = UIStackView(arrangedSubviews: [
            animalImage,
            wrapperVerticalStackView
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        contentView.backgroundColor = UIConstants.Colors.mainBackground
//        containerView.addSubview(horizontalStackView)
//        containerView.addSubview(verticalStackView)
        containerView.addSubview(mainStackView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = UIConstants.CornerRadiuses.block
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 320),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with animal: Animal) {
        currentImagePath = animal.photos.first?.medium ?? ""
        nameLabel.text = animal.name
        ageLabel.text = animal.age
        weightLabel.text = animal.size
        genderLabel.text = animal.gender
        breedLabel.text = animal.breeds.primary
        
        imageLoader.obtainImageWithPath(imagePath: animal.photos.first?.medium ?? "") { [weak self] (image) in
            if self?.currentImagePath == animal.photos.first?.medium ?? "" {
                self?.animalImage.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animalImage.image = nil
        currentImagePath = nil
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
