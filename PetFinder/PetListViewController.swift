//
//  PetListViewController.swift
//  PetFinder
//
//  Created by Kotya on 17/04/2025.
//

import UIKit

class PetListViewController: UIViewController {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var animals = ["Dog", "Cat", "Bird", "Fish", "Lizard", "Hamster", "Guinea pig"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
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
        
        tableView.register(PetCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }
}

extension PetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PetCell
//        cell.textLabel?.text = animals[indexPath.row]
        return cell
    }
}
