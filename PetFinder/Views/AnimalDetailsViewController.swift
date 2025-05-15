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

class AnimalDetailsViewController: UIViewController {
    
    private let animal: Animal
    let imageLoader = ImageLoader()

    init(animal: Animal) {
        self.animal = animal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    let contactsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.text = "Contacts:"
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 8
        map.heightAnchor.constraint(equalToConstant: 150).isActive = true
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
        photoCollectionView.register(AnimalCarouselImageCell.self, forCellWithReuseIdentifier: "carouselImageCell")
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }

    func setupView() {
        
        let contactsStackView = UIStackView(arrangedSubviews: [
            contactsLabel,
            emailLabel,
            phoneLabel
        ])
        contactsStackView.axis = .vertical
        contactsStackView.spacing = 8
        
        prepareCollectionView()
        
        view.addSubview(photoCollectionView)
        view.addSubview(photoPageControl)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(contactsStackView)
        view.addSubview(adoptButton)
        view.addSubview(mapView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoPageControl.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contactsStackView.translatesAutoresizingMaskIntoConstraints = false
        adoptButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoPageControl.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 4),
            photoPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contactsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            contactsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contactsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mapView.topAnchor.constraint(equalTo: contactsStackView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
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
        photoPageControl.numberOfPages = animal.photos.count
        nameLabel.text = animal.name
        descriptionLabel.text = animal.description
        emailLabel.text = animal.contact.email
        phoneLabel.text = animal.contact.phone
        adoptButton.isHidden = !showAdoptButton
        showAddressOnMap(animal.contact.address.address1)
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

