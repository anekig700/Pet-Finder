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
    
    private let viewModel: AnimalListViewModel
    
    init(viewModel: AnimalListViewModel = AnimalListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Colors.mainBackground
        safeArea = view.layoutMarginsGuide
        setupTableView()
        
        viewModel.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
            self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIConstants.Colors.mainBackground
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        tableView.register(AnimalTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension AnimalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfAnimals()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AnimalTableViewCell else {
            return UITableViewCell()
        }
        
        if let _ = viewModel.animal(at: indexPath.row) {
            cell.configure(with: viewModel.cellViewModels[indexPath.row])
        }
        
        return cell
    }
}

extension AnimalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let animal = viewModel.animal(at: indexPath.row) {
            navigationController?.pushViewController(AnimalDetailsViewController(viewModel: AnimalDetailsViewModel(animal: animal)), animated: true)
        }
    }
}
