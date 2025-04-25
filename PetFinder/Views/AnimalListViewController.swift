//
//  AnimalListViewController.swift
//  PetFinder
//
//  Created by Kotya on 17/04/2025.
//

import Combine
import UIKit

class AnimalListViewController: UIViewController {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    let imageLoader = ImageLoader()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel = AnimalViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        
        viewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        tableView.register(AnimalCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }
}

extension AnimalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.animals.count)
        return viewModel.animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AnimalCell
        cell.nameLabel.text = viewModel.animals[indexPath.row].name
        cell.ageLabel.text = viewModel.animals[indexPath.row].age
        cell.weightLabel.text = viewModel.animals[indexPath.row].size
        cell.genderLabel.text = viewModel.animals[indexPath.row].gender
        cell.breedLabel.text = viewModel.animals[indexPath.row].breeds.primary
        imageLoader.obtainImageWithPath(imagePath: viewModel.animals[indexPath.row].photos.first?.medium ?? "") { (image) in
            if let updateCell = tableView.cellForRow(at: indexPath) as? AnimalCell {
                updateCell.backgroundImage.image = image
                }
            }
        cell.selectionStyle = .none
        return cell
    }
}
