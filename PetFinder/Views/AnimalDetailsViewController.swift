//
//  AnimalDetailsViewController.swift
//  PetFinder
//
//  Created by Kotya on 09/05/2025.
//

import Foundation
import MapKit
import MessageUI
import UIKit
import Combine

class AnimalDetailsViewController: UIViewController {
    
    private let animal: Animal
    let imageLoader = ImageLoader()
    
    private var cancellables: Set<AnyCancellable> = []

    init(animal: Animal) {
        self.animal = animal
        self.viewModel = AnimalDetailsViewModel(id: animal.organization_id)
        super.init(nibName: nil, bundle: nil)
    }
    
    private let viewModel: AnimalDetailsViewModel

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var photoCollectionView: UICollectionView!
    
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
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 8
        map.heightAnchor.constraint(equalToConstant: 150).isActive = true
        map.isHidden = true
        return map
    }()
    
    var organizationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let organizationLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        return imageView
    }()
    
    let chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor.tertiaryLabel
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    let spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 4).isActive = true
        return view
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
    
    let photoPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        fillView()
        
        viewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.organizationNameLabel.text = self?.viewModel.organization?.organization.name
                self?.imageLoader.obtainImageWithPath(imagePath: self?.viewModel.organization?.organization.photos.first?.medium ?? "") { (image) in
                    self?.organizationLogo.image = image
                }
        }.store(in: &cancellables)
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.layer.cornerRadius = 8
        photoCollectionView.isPagingEnabled = true
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        photoCollectionView.backgroundColor = .clear
        photoCollectionView.isHidden = true
        photoCollectionView.register(AnimalCarouselImageCell.self, forCellWithReuseIdentifier: "carouselImageCell")
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }

    func setupView() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    
        prepareCollectionView()
        
        let horizontalStackView = UIStackView(arrangedSubviews: [
            organizationLogo,
            organizationNameLabel,
            chevron,
            spacer
        ])
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 16
        horizontalStackView.layer.borderWidth = 1.0
        horizontalStackView.layer.borderColor = UIColor.lightGray.cgColor
        horizontalStackView.layer.cornerRadius = 8
        horizontalStackView.clipsToBounds = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(horizontalStackViewTapped))
        horizontalStackView.isUserInteractionEnabled = true
        horizontalStackView.addGestureRecognizer(tapGesture)
        
        contentView.addSubview(photoCollectionView)
        contentView.addSubview(photoPageControl)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(mapView)
        contentView.addSubview(horizontalStackView)
        view.addSubview(adoptButton)
        view.bringSubviewToFront(adoptButton)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoPageControl.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        adoptButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            photoCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photoPageControl.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 4),
            photoPageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: photoPageControl.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            horizontalStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mapView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            adoptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            adoptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            adoptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
    
    private var showAdoptButton: Bool {
        if animal.contact.email != nil {
            return true
        } else if animal.contact.phone != nil {
            return true
        }
        return false
    }
    
    func fillView() {
        photoCollectionView.isHidden = animal.photos.isEmpty
        photoPageControl.numberOfPages = animal.photos.count
        photoPageControl.isHidden = animal.photos.count <= 1
        nameLabel.text = animal.name
        descriptionLabel.text = animal.description
        adoptButton.isHidden = !showAdoptButton
        if let fullAddress = animal.contact.address.fullAddress {
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
        
        if let phoneNumber = animal.contact.phone {
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
        
        if let emailAddress = animal.contact.email {
            let emailAction = UIAlertAction(title: "Email \(emailAddress)", style: .default) { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mailVC = MFMailComposeViewController()
                    mailVC.mailComposeDelegate = self
                    mailVC.setToRecipients([emailAddress])
                    mailVC.setSubject("Adopt \(self.animal.name)")
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
        guard let organization = viewModel.organization else { return }
        let newVC = OrganizationDetailsViewController(organization: organization.organization)
        navigationController?.pushViewController(newVC, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension AnimalDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension AnimalDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        animal.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselImageCell", for: indexPath) as! AnimalCarouselImageCell
        imageLoader.obtainImageWithPath(imagePath: animal.photos[indexPath.row].medium) { (image) in
            cell.photoImageView.image = image
        }
//        cell.configure(with: UIImage(named: images[indexPath.item]))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AnimalDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        guard pageWidth > 0 else { return }

        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let currentPage = Int(round(fractionalPage))

        photoPageControl.currentPage = max(0, min(currentPage, photoPageControl.numberOfPages - 1))
    }
}

