//
//  AnimalCell.swift
//  PetFinder
//
//  Created by Kotya on 20/04/2025.
//

import UIKit

class AnimalCell: UITableViewCell {
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
     }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .tertiaryLabel
        label.text = "Name"
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
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .secondaryLabel
        label.text = "Breed"
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
            breedLabel,
            weightLabel
        ])
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 5
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            nameLabel,
            horizontalStackView
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [
            verticalStackView
        ])
        mainStackView.axis = .horizontal
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 40),
            verticalStackView.topAnchor.constraint(greaterThanOrEqualTo: mainStackView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 12),
            verticalStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -8),
            verticalStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -12),
            self.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        self.backgroundView = backgroundImage
        mainStackView.backgroundColor = .white.withAlphaComponent(0.8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
