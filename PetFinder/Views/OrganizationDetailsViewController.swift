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
    
    init(organization: Organization) {
        self.organization = organization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
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
        view.backgroundColor = .white
        setupView()
        fillView()
    }

    func setupView() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(mapView)
        view.addSubview(adoptButton)
        view.bringSubviewToFront(adoptButton)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        adoptButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
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
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mapView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
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
//    
//    @objc func horizontalStackViewTapped() {
//        let newVC = AnimalListViewController()
//        navigationController?.pushViewController(newVC, animated: true)
//    }
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
//
//// MARK: - UICollectionViewDataSource
//
//extension OrganizationDetailsViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        organization.photos.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselImageCell", for: indexPath) as! AnimalCarouselImageCell
//        imageLoader.obtainImageWithPath(imagePath: organization.photos[indexPath.row].medium) { (image) in
//            cell.photoImageView.image = image
//        }
////        cell.configure(with: UIImage(named: images[indexPath.item]))
//        return cell
//    }
//}

