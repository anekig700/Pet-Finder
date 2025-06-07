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
        self.viewModel = AnimalListViewModel(query: "?organization=\(organization.id)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: AnimalListViewModel
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var animalCollectionView: UICollectionView!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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
        label.font = .systemFont(ofSize: 16, weight: .medium)
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
        return imageView
    }()
    
    let spacer: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 2).isActive = true
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.lineBreakStrategy = .pushOut
        label.numberOfLines = 0
        return label
    }()
    
    let mapHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.text = "How to find us"
        return label
    }()
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 8
        map.heightAnchor.constraint(equalToConstant: 150).isActive = true
        map.isHidden = true
        return map
    }()
    
    let adoptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Contact Organization", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.addTarget(self, action: #selector(showContactMenu), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemGroupedBackground
        self.title = "Organization Details"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupView()
        fillView()
        
        viewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
            self?.animalCollectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 150)
//        let totalHeight = 150 * viewModel.animals.count
        
        animalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        animalCollectionView.layer.cornerRadius = 8
//        animalCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(totalHeight)).isActive = true
        animalCollectionView.backgroundColor = .clear
//        animalCollectionView.isHidden = true
        animalCollectionView.register(AnimalCollectionViewCell.self, forCellWithReuseIdentifier: "animalCollectionViewCell")
        animalCollectionView.dataSource = self
//        animalCollectionView.delegate = self
    }

    func setupView() {
        
        let horizontalHeaderStackView = UIStackView(arrangedSubviews: [
            logoImage,
            nameLabel
        ])
        horizontalHeaderStackView.alignment = .center
        horizontalHeaderStackView.distribution = .fill
        horizontalHeaderStackView.axis = .horizontal
        horizontalHeaderStackView.spacing = 8
        
        self.imageLoader.obtainImageWithPath(imagePath: organization.photos.first?.medium ?? "") { [weak self] (image) in
            self?.logoImage.image = image
        }
        
        let verticalInfoContainer: UIView = {
            let view = UIView()
            view.addSubview(horizontalHeaderStackView)
            view.addSubview(descriptionLabel)
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            view.backgroundColor = .white
            return view
        }()
        NSLayoutConstraint.activate([
            horizontalHeaderStackView.topAnchor.constraint(equalTo: verticalInfoContainer.topAnchor, constant: 16),
            horizontalHeaderStackView.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: 16),
            horizontalHeaderStackView.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -16),
            horizontalHeaderStackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -16),
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
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            view.backgroundColor = .white
            return view
        }()
        NSLayoutConstraint.activate([
            mapHeaderLabel.topAnchor.constraint(equalTo: verticalMapContainer.topAnchor, constant: 16),
            mapHeaderLabel.leadingAnchor.constraint(equalTo: verticalMapContainer.leadingAnchor, constant: 16),
            mapHeaderLabel.trailingAnchor.constraint(equalTo: verticalMapContainer.trailingAnchor, constant: -16),
            mapHeaderLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -12),
            mapView.leadingAnchor.constraint(equalTo: verticalMapContainer.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: verticalMapContainer.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -12),
            horizontalStackView.leadingAnchor.constraint(equalTo: verticalMapContainer.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: verticalMapContainer.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: verticalMapContainer.bottomAnchor, constant: -16),
        ])
        
        let organizationInfoContainer = verticalInfoContainer.wrapInShadowContainer()
        let mapContainer = verticalMapContainer.wrapInShadowContainer()
        
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
        
        prepareCollectionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(horizontalStackViewTapped))
        horizontalStackView.isUserInteractionEnabled = true
        horizontalStackView.addGestureRecognizer(tapGesture)
        
        view.addSubview(organizationInfoContainer)
        view.addSubview(mapContainer)
//        view.addSubview(horizontalStackView)
//        view.addSubview(mapView)
        view.addSubview(animalCollectionView)
        view.addSubview(adoptButton)
        view.bringSubviewToFront(adoptButton)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        organizationInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        mapContainer.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        adoptButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        mapHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        animalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            organizationInfoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            organizationInfoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            organizationInfoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapContainer.topAnchor.constraint(equalTo: organizationInfoContainer.bottomAnchor, constant: 8),
            mapContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            horizontalStackView.topAnchor.constraint(equalTo: organizationInfoContainer.bottomAnchor, constant: 8),
//            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            mapView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            animalCollectionView.topAnchor.constraint(equalTo: mapContainer.bottomAnchor, constant: 16),
            animalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            animalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            animalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -38),
            adoptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            adoptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            adoptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
    
    private var showAdoptButton: Bool {
        if organization.email != nil {
            return true
        } else if organization.phone != nil {
            return true
        }
        return false
    }
    
    func fillView() {
        nameLabel.text = organization.name
        descriptionLabel.text = organization.mission_statement
        adoptButton.isHidden = !showAdoptButton
        webLabel.text = organization.website
        if let fullAddress = organization.address.fullAddress {
            mapView.isHidden = false
            showAddressOnMap(fullAddress)
        }   
    }
    
    func showAddressOnMap(_ address: String?) {
        guard let address = address else { return }
        let geocoder = CLGeocoder()
            
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self = self else { return }
                
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
                
            guard let placemark = placemarks?.first,
                let location = placemark.location else {
                print("No matching location found")
                return
            }
                
            let coordinate = location.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = address
                
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            ), animated: true)
        }
    }
    
    @objc func showContactMenu() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if let phoneNumber = organization.phone {
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
        
        if let emailAddress = organization.email {
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
        viewModel.numberOfAnimals()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let animal = viewModel.animal(at: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCollectionViewCell", for: indexPath) as! AnimalCollectionViewCell
        if let animal = viewModel.animal(at: indexPath.row) {
            cell.nameLabel.text = animal.name
            imageLoader.obtainImageWithPath(imagePath: animal.photos.first?.medium ?? "") { (image) in
                if let updateCell = collectionView.cellForItem(at: indexPath) as? AnimalCollectionViewCell {
                    updateCell.photoImageView.image = image
                }
            }
        }
//        cell.nameLabel.text = animal.name
//        imageLoader.obtainImageWithPath(imagePath: animal.photos.first?.medium ?? "") { (image) in
//            if let updateCell = collectionView.cellForItem(at: indexPath) as? AnimalCollectionViewCell {
//                updateCell.photoImageView.image = image
//            }
//        }
//        cell.configure(with: UIImage(named: images[indexPath.item]))
        return cell
    }
}

extension OrganizationDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.bounds.size
    }
}

