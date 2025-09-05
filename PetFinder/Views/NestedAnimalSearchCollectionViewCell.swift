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
        return collectionView
    }()
    
    private var items: [Type] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(horizontalCollectionView)
//        horizontalCollectionView.delegate = self
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
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
//    }
}
