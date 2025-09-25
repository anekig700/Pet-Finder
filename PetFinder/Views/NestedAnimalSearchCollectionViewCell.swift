//
//  NestedAnimalSearchCollectionViewCell.swift
//  PetFinder
//
//  Created by Kotya on 05/09/2025.
//

import UIKit

class NestedAnimalSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "NestedAnimalSearchCollectionViewCell"
    
    enum Question {
        case names([Type])
        case types([String])
    }
    
    var questionType: Question?
    private var names: [String] = []
    private var coats: [String] = []
    
    let horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private var count: Int = 0
    
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
        self.count = items.count
        self.questionType = .names(items)
        horizontalCollectionView.reloadData()
    }
    
    func configure(with properties: [String]) {
        self.count = properties.count
        self.questionType = .types(properties)
        horizontalCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension NestedAnimalSearchCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InnerAnimalSearchCollectionViewCell.identifier, for: indexPath) as? InnerAnimalSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch questionType {
        case .names(let types):
            cell.configure(with: types[indexPath.row].name)
        case .types(let type):
            cell.configure(with: type[indexPath.row])
        case .none:
            break
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
