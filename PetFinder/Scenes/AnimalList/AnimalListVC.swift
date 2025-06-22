//
//  AnimalListVC.swift
//  PetFinder
//
//  Created by Kotya on 22/06/2025.
//

import UIKit

class AnimalListVC: UIViewController {
    
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    private let viewModel: AnimalListVM
    private let imageLoader = ImageLoader()
    
    init(viewModel: AnimalListVM = AnimalListVM()) {
        self.viewModel = viewModel
        print("🐱 2) VC -> init")
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
        
        print("🐱 3) VC -> viewDidLoad")
        
        viewModel.viewModelDidChange = { [weak self] in
            // the body is waiting for execution
            print("🐱 4) VC -> CLOSURE BODY")
            self?.tableView.reloadData()
        }
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

extension AnimalListVC: UITableViewDataSource {
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

extension AnimalListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let animal = viewModel.animal(at: indexPath.row) {
            navigationController?.pushViewController(AnimalDetailsViewController(viewModel: AnimalDetailsViewModel(animal: animal)), animated: true)
        }
    }
}
