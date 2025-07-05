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
    
    let imageLoader = ImageLoader()
    
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: AnimalDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let viewModel: AnimalDetailsViewModel

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var photoCollectionView: UICollectionView!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.primary
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.secondary
        label.textColor = .black
        label.lineBreakStrategy = .pushOut
        label.numberOfLines = 0
        return label
    }()
    
    let mapView : MKMapView = {
        let map = MapView()
        map.isHidden = true
        return map
    }()
    
    var organizationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.secondary
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.isHidden = true
        return label
    }()
    
    let organizationLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = UIConstants.CornerRadiuses.block
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.layer.borderWidth = 1
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.isHidden = true
        return imageView
    }()
    
    let chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.isHidden = true
        return imageView
    }()
    
    let leftSpacer: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 8).isActive = true
        return view
    }()
    
    let rightSpacer: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 8).isActive = true
        return view
    }()
    
    let adoptButton: UIButton = {
        let button = CTAButton()
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
        view.backgroundColor = UIConstants.Colors.mainBackground
        self.title = "Animal Details"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupView()
        fillView()
        
        viewModel.$organizationViewModelState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] organizationViewModelState in
                self?.organizationNameLabel.text = organizationViewModelState?.organizationName
                self?.imageLoader.obtainImageWithPath(imagePath: organizationViewModelState?.organizationLogo ?? "")
                { (image) in
                    self?.organizationLogo.image = image
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.chevron.isHidden = false
                    self?.organizationLogo.isHidden = false
                    self?.organizationNameLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.layer.cornerRadius = UIConstants.CornerRadiuses.block
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
            leftSpacer,
            organizationLogo,
            organizationNameLabel,
            chevron,
            rightSpacer,
            activityIndicator
        ])
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.backgroundColor = .white
        horizontalStackView.layer.cornerRadius = UIConstants.CornerRadiuses.block
        horizontalStackView.clipsToBounds = true
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: horizontalStackView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor)
        ])
        
        let verticalInfoContainer: UIView = {
            let view = UIView()
            view.addSubview(nameLabel)
            view.addSubview(descriptionLabel)
            view.layer.cornerRadius = UIConstants.CornerRadiuses.block
            view.clipsToBounds = true
            view.backgroundColor = .white
            return view
        }()
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: verticalInfoContainer.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            nameLabel.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            nameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: verticalInfoContainer.leadingAnchor, constant: UIConstants.Padding.horizontal),
            descriptionLabel.trailingAnchor.constraint(equalTo: verticalInfoContainer.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            descriptionLabel.bottomAnchor.constraint(equalTo: verticalInfoContainer.bottomAnchor, constant: -16),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(horizontalStackViewTapped))
        horizontalStackView.isUserInteractionEnabled = true
        horizontalStackView.addGestureRecognizer(tapGesture)
        
        let animalInfoContainer = verticalInfoContainer.wrapInShadowContainer()
        let organizationInfoContainer = horizontalStackView.wrapInShadowContainer()
        let mapContainer = mapView.wrapInShadowContainer()
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(mapTapGesture)
        
        contentView.addSubview(photoCollectionView)
        contentView.addSubview(photoPageControl)
        contentView.addSubview(animalInfoContainer)
        contentView.addSubview(mapContainer)
        contentView.addSubview(organizationInfoContainer)
        view.addSubview(adoptButton)
        view.bringSubviewToFront(adoptButton)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoPageControl.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        adoptButton.translatesAutoresizingMaskIntoConstraints = false
        mapContainer.translatesAutoresizingMaskIntoConstraints = false
        organizationInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        animalInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
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
            photoCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            photoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            photoPageControl.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 10),
            photoPageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animalInfoContainer.topAnchor.constraint(equalTo: photoPageControl.bottomAnchor, constant: 10),
            animalInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            animalInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            organizationInfoContainer.topAnchor.constraint(equalTo: verticalInfoContainer.bottomAnchor, constant: 16),
            organizationInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            organizationInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            organizationInfoContainer.heightAnchor.constraint(equalToConstant: 49),
            mapContainer.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
            mapContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.horizontal),
            mapContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            mapContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -62),
            adoptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Padding.horizontal),
            adoptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Padding.horizontal),
            adoptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
    
    func fillView() {
        photoCollectionView.isHidden = viewModel.animalViewModelState.photos.isEmpty
        photoPageControl.numberOfPages = viewModel.animalViewModelState.photosCount
        photoPageControl.isHidden = viewModel.animalViewModelState.photosCount <= 1
        nameLabel.text = viewModel.animalViewModelState.name
        descriptionLabel.text = viewModel.animalViewModelState.description
        adoptButton.isHidden = !viewModel.animalViewModelState.shouldShowContactButton
        if let fullAddress = viewModel.animalViewModelState.address {
            mapView.isHidden = false
            mapView.showAddressOnMap(fullAddress)
        }   
    }
    
    @objc func showContactMenu() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if let phoneNumber = viewModel.animalViewModelState.phone {
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
        
        if let emailAddress = viewModel.animalViewModelState.email {
            let emailAction = UIAlertAction(title: "Email \(emailAddress)", style: .default) { [weak self] _ in
                if MFMailComposeViewController.canSendMail() {
                    guard let self = self else { return }
                    let mailVC = MFMailComposeViewController()
                    mailVC.mailComposeDelegate = self
                    mailVC.setToRecipients([emailAddress])
                    mailVC.setSubject("Adopt \(self.viewModel.animalViewModelState.name)")
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
        guard let organization = viewModel.organization() else { return }
        let organizationDetailsVC = OrganizationDetailsViewController(organization: organization)
        navigationController?.pushViewController(organizationDetailsVC, animated: true)
    }
    
    @objc func mapViewTapped() {
        guard let address = viewModel.animalViewModelState.address else { return }
        geocodeAndOpenInMaps(address)
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
        viewModel.animalViewModelState.photosCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselImageCell", for: indexPath) as? AnimalCarouselImageCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.animalViewModelState, at: indexPath.row)
        
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

