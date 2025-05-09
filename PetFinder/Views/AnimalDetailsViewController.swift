//
//  AnimalDetailsViewController.swift
//  PetFinder
//
//  Created by Kotya on 09/05/2025.
//

import Foundation
import UIKit

class AnimalDetailsViewController: UIViewController {
    
    private let animal: Animal

    init(animal: Animal) {
        self.animal = animal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.lineBreakStrategy = .pushOut
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        fillView()
    }

    func setupView() {
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            descriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor)
        ])
    }
    
    func fillView() {
        nameLabel.text = animal.name
        descriptionLabel.text = animal.description ?? nil
    }
}


