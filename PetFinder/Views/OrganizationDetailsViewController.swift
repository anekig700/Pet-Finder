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
        self.viewModel = AnimalViewControllerViewModel(query: "?organization=\(organization.id)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: AnimalViewControllerViewModel
    
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
        
        let verticalInfoContainer: UIView = {
            let view = UIView()
            view.addSubview(nameLabel)
            view.addSubview(descriptionLabel)
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            view.backgroundColor = .white
            return view
        }()
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: verticalInfoContainer.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: verticalInfoContainer.bottomAnchor, constant: -16),
        ])
        
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
        
        prepareCollectionView()
        
        let horizontalStackView = UIStackView(arrangedSubviews: [
            webLabel,
            icon,
            spacer
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 6
        horizontalStackView.alignment = .center
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(horizontalStackViewTapped))
        horizontalStackView.isUserInteractionEnabled = true
        horizontalStackView.addGestureRecognizer(tapGesture)
        
        let organizationInfoContainer = verticalInfoContainer.wrapInShadowContainer()
        
        view.addSubview(organizationInfoContainer)
//        view.addSubview(nameLabel)
//        view.addSubview(descriptionLabel)
        view.addSubview(horizontalStackView)
        view.addSubview(mapView)
        view.addSubview(animalCollectionView)
        view.addSubview(adoptButton)
        view.bringSubviewToFront(adoptButton)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        organizationInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        adoptButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        animalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
//            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            organizationInfoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            organizationInfoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            organizationInfoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            horizontalStackView.topAnchor.constraint(equalTo: organizationInfoContainer.bottomAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mapView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            animalCollectionView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
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
//        if let fullAddress = organization.contact.address.fullAddress {
//            mapView.isHidden = false
//            showAddressOnMap(fullAddress)
//        }   
    }
    
//    func showAddressOnMap(_ address: String?) {
//        guard let address = address else { return }
//        let geocoder = CLGeocoder()
//            
//        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
//            guard let self = self else { return }
//                
//            if let error = error {
//                print("Geocoding failed: \(error.localizedDescription)")
//                return
//            }
//                
//            guard let placemark = placemarks?.first,
//                let location = placemark.location else {
//                print("No matching location found")
//                return
//            }
//                
//            let coordinate = location.coordinate
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = address
//                
//            self.mapView.addAnnotation(annotation)
//            self.mapView.setRegion(MKCoordinateRegion(
//                center: coordinate,
//                latitudinalMeters: 1000,
//                longitudinalMeters: 1000
//            ), animated: true)
//        }
//    }
//    
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
        viewModel.animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCollectionViewCell", for: indexPath) as! AnimalCollectionViewCell
        cell.nameLabel.text = viewModel.animals[indexPath.row].name
        imageLoader.obtainImageWithPath(imagePath: viewModel.animals[indexPath.row].photos.first?.medium ?? "") { (image) in
            if let updateCell = collectionView.cellForItem(at: indexPath) as? AnimalCollectionViewCell {
                updateCell.photoImageView.image = image
            }
        }
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

