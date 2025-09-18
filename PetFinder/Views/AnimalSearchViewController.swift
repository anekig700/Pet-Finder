//
//  AnimalSearchViewController.swift
//  PetFinder
//
//  Created by Kotya on 19/07/2025.
//

import UIKit
import Combine

class AnimalSearchViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var heightConstraint: NSLayoutConstraint!
    private var isExpanded = false
    
    private let viewModel: AnimalSearchViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: AnimalSearchViewModel = AnimalSearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIConstants.Colors.mainBackground
        setupCollectionView()
        bindViewModel()
        viewModel.didLoadView()
    }
    
    private func bindViewModel() {
        viewModel.$types
            .receive(on: DispatchQueue.main)
            .sink { [weak self] types in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.isActive = true
        
        collectionView.register(NestedAnimalSearchCollectionViewCell.self, forCellWithReuseIdentifier: NestedAnimalSearchCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func expandCollectionView() {
            guard !isExpanded else { return }
            isExpanded = true

            UIView.animate(withDuration: 0.3) {
                self.heightConstraint.constant = CGFloat(5) * 90
                self.view.layoutIfNeeded()
            }

            collectionView.performBatchUpdates({
                self.collectionView.reloadData()
            }, completion: nil)
        }
    
}

// MARK: - UICollectionViewDataSource

extension AnimalSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NestedAnimalSearchCollectionViewCell.identifier, for: indexPath) as! NestedAnimalSearchCollectionViewCell
        let types = viewModel.types
        if indexPath.item == 0 {
            cell.onInnerCellTap = { [weak self] indexPath in
                self?.expandCollectionView()
            }
            cell.configure(with: types)
        } else {
            cell.configure(with: types)
        }

        return cell
    }
}

extension AnimalSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        if let animalTypeName = viewModel.type(at: indexPath.row)?.name {
//            viewModel.didSelectAnimalType(animalTypeName)
//        }
    }
}

extension AnimalSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}
