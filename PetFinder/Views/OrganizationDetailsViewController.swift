//
//  OrganizationDetailsViewController.swift
//  PetFinder
//
//  Created by Kotya on 22/05/2025.
//

import Foundation
import MapKit
import MessageUI
import UIKit
import Combine

class OrganizationDetailsViewController: UIViewController {
    
    private let organization: Organization
    let imageLoader = ImageLoader()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(organization: Organization) {
        self.organization = organization
        self.viewModel = OrganizationDetailsViewModel(organization: organization)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: OrganizationDetailsViewModel
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var animalCollectionView: UICollectionView!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.primary
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    
    let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.layer.borderWidth = 1
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    let webLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIConstants.Fonts.primary
        label.textColor = .systemBlue
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.forward.app")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.isHidden = true
        return imageView
    }()
    
    let spacer: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 2).isActive = true
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.secondary
        label.textColor = .black
        label.lineBreakStrategy = .pushOut
        label.numberOfLines = 0
        return label
    }()
    
    let mapHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.primary
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.text = "How to find us"
        return label
    }()
    
    let mapView: MKMapView = {
        let map = MapView()
        map.isHidden = true
        return map
    }()
    
    let animalsHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.primary
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.text = "Our animals"
        return label
    }()
    
    let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
//        button.isHidden = true
        return button
    }()
    
    let adoptButton: UIButton = {
        let button = CTAButton()
        button.addTarget(self, action: #selector(showContactMenu), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Colors.mainBackground
        self.title = "Organization Details"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupView()
        fillView()
        
        viewModel.animalListVM.$animals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.animalCollectionView.reloadData()
                self?.animalCollectionView.layoutIfNeeded()
                self?.collectionViewHeightConstraint.constant = self?.animalCollectionView.contentSize.height ?? 0
            }
            .store(in: &cancellables)
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        let itemsPerRow: CGFloat = 2
        let totalSpacing = (itemsPerRow - 1) * spacing
        let width = (view.bounds.width - totalSpacing - 16 * 4) / itemsPerRow

        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

//        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        let totalHeight = 150 * viewModel.animals.count
        
        animalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewHeightConstraint = animalCollectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionViewHeightConstraint.isActive = true
        animalCollectionView.backgroundColor = .clear
//        animalCollectionView.isHidden = true
        animalCollectionView.register(AnimalCollectionViewCell.self, forCellWithReuseIdentifier: "animalCollectionViewCell")
        animalCollectionView.dataSource = self
        animalCollectionView.isScrollEnabled = false
        animalCollectionView.delegate = self
    }

    func setupView() {
        
        prepareCollectionView()
        
        let horizontalHeaderStackView = UIStackView(arrangedSubviews: [
            logoImage,
            nameLabel
        ])
        horizontalHeaderStackView.alignment = .center
        horizontalHeaderStackView.distribution = .fill
        horizontalHeaderStackView.axis = .horizontal
        horizontalHeaderStackView.spacing = 8
        
        self.imageLoader.obtainImageWithPath(imagePath: viewModel.state.photo) { [weak self] (image) in
            self?.logoImage.image = image
        }
        
        let verticalInfoContainer: UIView = {
            let view = UIView()
            view.addSubview(horizontalHeaderStackView)
            view.addSubview(descriptionLabel)
            view.layer.cornerRadius = UIConstants.CornerRadiuses.block
            view.clipsToBounds = true
            view.backgroundColor = .white
            return view
        }()
        NSLayoutConstraint.activate([
            horizontalHeaderStackView.topAnchor.constraint(equalTo: verticalInfoContainer.topAnchor, constant: 16),
            horizontalHeaderStackView.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            horizontalHeaderStackView.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            horizontalHeaderStackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            descriptionLabel.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            descriptionLabel.bottomAnchor.constraint(equalTo: verticalInfoContainer.bottomAnchor, constant: -16),
        ])
        
        let horizontalStackView = UIStackView(arrangedSubviews: [
            webLabel,
            icon,
            spacer
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 6
        horizontalStackView.alignment = .center
        
        let verticalMapContainer: UIView = {
            let view = UIView()
            view.addSubview(mapHeaderLabel)
            view.addSubview(mapView)
            view.addSubview(horizontalStackView)
            view.layer.cornerRadius = UIConstants.CornerRadiuses.block
            view.clipsToBounds = true
            view.backgroundColor = .white
            return view
        }()
        NSLayoutConstraint.activate([
            mapHeaderLabel.topAnchor.constraint(equalTo: verticalMapContainer.topAnchor, constant: 16),
            mapHeaderLabel.leadingAnchor.constraint(equalTo: verticalMapContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            mapHeaderLabel.trailingAnchor.constraint(equalTo: verticalMapContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            mapHeaderLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -12),
            mapView.leadingAnchor.constraint(equalTo: verticalMapContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            mapView.trailingAnchor.constraint(equalTo: verticalMapContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            mapView.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -12),
            horizontalStackView.leadingAnchor.constraint(equalTo: verticalMapContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            horizontalStackView.trailingAnchor.constraint(equalTo: verticalMapContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            horizontalStackView.bottomAnchor.constraint(equalTo: verticalMapContainer.bottomAnchor, constant: -16),
        ])
        
        let verticalAnimalsContainer: UIView = {
            let view = UIView()
            view.addSubview(animalsHeaderLabel)
            view.addSubview(animalCollectionView)
            view.addSubview(seeAllButton)
            view.layer.cornerRadius = UIConstants.CornerRadiuses.block
            view.clipsToBounds = true
            view.backgroundColor = .white
            return view
        }()
        NSLayoutConstraint.activate([
            animalsHeaderLabel.topAnchor.constraint(equalTo: verticalAnimalsContainer.topAnchor, constant: 16),
            animalsHeaderLabel.leadingAnchor.constraint(equalTo: verticalAnimalsContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            animalsHeaderLabel.trailingAnchor.constraint(equalTo: verticalAnimalsContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            animalsHeaderLabel.bottomAnchor.constraint(equalTo: animalCollectionView.topAnchor, constant: -12),
            animalCollectionView.leadingAnchor.constraint(equalTo: verticalAnimalsContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            animalCollectionView.trailingAnchor.constraint(equalTo: verticalAnimalsContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
//            animalCollectionView.bottomAnchor.constraint(equalTo: verticalAnimalsContainer.bottomAnchor, constant: -16),
            seeAllButton.topAnchor.constraint(equalTo: animalCollectionView.bottomAnchor, constant: 16),
            seeAllButton.trailingAnchor.constraint(equalTo: verticalAnimalsContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            seeAllButton.bottomAnchor.constraint(equalTo: verticalAnimalsContainer.bottomAnchor, constant: -16)
        ])
        
        let organizationInfoContainer = verticalInfoContainer.wrapInShadowContainer()
        let mapContainer = verticalMapContainer.wrapInShadowContainer()
        let animalsContainer = verticalAnimalsContainer.wrapInShadowContainer()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(horizontalStackViewTapped))
        horizontalStackView.isUserInteractionEnabled = true
        horizontalStackView.addGestureRecognizer(tapGesture)
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapView.addGestureRecognizer(mapTapGesture)
        
        contentView.addSubview(organizationInfoContainer)
        contentView.addSubview(mapContainer)
        contentView.addSubview(animalsContainer)
        view.addSubview(adoptButton)
        view.bringSubviewToFront(adoptButton)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        organizationInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        mapContainer.translatesAutoresizingMaskIntoConstraints = false
        animalsContainer.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        adoptButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        mapHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        animalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        animalsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalAnimalsContainer.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            organizationInfoContainer.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            organizationInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            organizationInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            mapContainer.topAnchor.constraint(equalTo: organizationInfoContainer.bottomAnchor, constant: 16),
            mapContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            mapContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            animalsContainer.topAnchor.constraint(equalTo: mapContainer.bottomAnchor, constant: 16),
            animalsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            animalsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            animalsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            adoptButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            adoptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            adoptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
    
    func fillView() {
        nameLabel.text = viewModel.state.name
        descriptionLabel.text = viewModel.state.description
        adoptButton.isHidden = !viewModel.state.shouldShowContactButton
        webLabel.text = viewModel.state.website
        icon.isHidden = !viewModel.state.shouldShowIcon
        if let fullAddress = viewModel.state.address {
            mapView.isHidden = false
            mapView.showAddressOnMap(fullAddress)
        }
    }
    
    @objc func showContactMenu() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if let phoneNumber = viewModel.state.phone {
            let callAction = UIAlertAction(title: "Call \(phoneNumber)", style: .default) { _ in
                if let phoneURL = URL(string: "tel://\(phoneNumber)"),
                   UIApplication.shared.canOpenURL(phoneURL) {
                    UIApplication.shared.open(phoneURL)
                } else {
                    print("Cannot make a call.")
                }
            }
            
            alert.addAction(callAction)
        }
        
        if let emailAddress = viewModel.state.email {
            let emailAction = UIAlertAction(title: "Email \(emailAddress)", style: .default) { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mailVC = MFMailComposeViewController()
                    mailVC.mailComposeDelegate = self
                    mailVC.setToRecipients([emailAddress])
                    mailVC.setMessageBody("Hi there,", isHTML: false)
                    self.present(mailVC, animated: true)
                } else {
                    print("Cannot send email. Configure an email account.")
                }
            }
            alert.addAction(emailAction)
        }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func horizontalStackViewTapped() {
        if let url = URL(string: webLabel.text!) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func mapTapped() {
        guard let address = viewModel.state.address else { return }
        geocodeAndOpenInMaps(address)
    }
    
    @objc func seeAllTapped() {
        navigationController?.pushViewController(AnimalListViewController(viewModel: AnimalListViewModel(query: "?organization=\(organization.id)")), animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension OrganizationDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension OrganizationDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.animalListVM.numberOfAnimals() < 6 {
            return viewModel.animalListVM.numberOfAnimals()
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCollectionViewCell", for: indexPath) as! AnimalCollectionViewCell
        if let animal = viewModel.animalListVM.animal(at: indexPath.row) {
            cell.nameLabel.text = "  " + animal.name + "  "
            imageLoader.obtainImageWithPath(imagePath: animal.photos.first?.medium ?? "") { (image) in
                if let updateCell = collectionView.cellForItem(at: indexPath) as? AnimalCollectionViewCell {
                    updateCell.photoImageView.image = image
                }
            }
        }
        return cell
    }
}

extension OrganizationDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let animal = viewModel.animalListVM.animal(at: indexPath.row) {
            navigationController?.pushViewController(AnimalDetailsViewController(viewModel: AnimalDetailsViewModel(animal: animal)), animated: true)
        }
    }
}


