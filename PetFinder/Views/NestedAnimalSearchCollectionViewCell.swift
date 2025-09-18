//
//  NestedAnimalSearchCollectionViewCell.swift
//  PetFinder
//
//  Created by Kotya on 05/09/2025.
//

import UIKit

class NestedAnimalSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "NestedAnimalSearchCollectionViewCell"
    
    let horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private var items: [Type] = []
    
    var onInnerCellTap: ((_ indexPath: IndexPath) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(horizontalCollectionView)
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.register(InnerAnimalSearchCollectionViewCell.self, forCellWithReuseIdentifier: InnerAnimalSearchCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        horizontalCollectionView.frame = contentView.bounds
    }
    
    func configure(with items: [Type]) {
        self.items = items
        horizontalCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension NestedAnimalSearchCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InnerAnimalSearchCollectionViewCell.identifier, for: indexPath) as? InnerAnimalSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            cell.configure(with: items[indexPath.row].name)
        } else {
            cell.configure(with: items[indexPath.row].coats[indexPath.row])
        }
        
        return cell
    }
}

extension NestedAnimalSearchCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        if let animalTypeName = viewModel.type(at: indexPath.row)?.name {
//            viewModel.didSelectAnimalType(animalTypeName)
//        }
        onInnerCellTap?(indexPath)
    }
}
