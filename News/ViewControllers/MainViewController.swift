//
//  ViewController.swift
//  News
//
//  Created by Анатолий Миронов on 24.11.2021.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let newsRussia = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let newsUSA = [1, 2, 3, 4, 5]

    lazy var rowsToDisplay = newsRussia
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, tableView])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy private var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Russia", "USA"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSegmentControl), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        setStackViewConstraints()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .white
        title = "Hello"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        cell.textLabel?.text = "\(rowsToDisplay[indexPath.row])"
        return cell
    }
    
    @objc private func changeSegmentControl() {
        rowsToDisplay = segmentedControl.selectedSegmentIndex == 0 ? newsRussia : newsUSA
        tableView.reloadData()
    }
    
    private func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

