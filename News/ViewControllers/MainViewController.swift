//
//  ViewController.swift
//  News
//
//  Created by Анатолий Миронов on 24.11.2021.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var newsRussia: [Articles] = []
    var newsUSA: [Articles] = []

    lazy var rowsToDisplay = newsRussia
    
    lazy private var paddedStackView: UIStackView = {
        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
        paddedStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
        return paddedStackView
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [paddedStackView, tableView])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy private var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Russia", "USA"])
        segmentedControl.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSegmentControl), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.cellID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "News"
        
        view.addSubview(stackView)
        setStackViewConstraints()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        getNews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.cellID, for: indexPath) as? ArticleCell else { return UITableViewCell() }
        
        let news = rowsToDisplay[indexPath.row]
        cell.configure(cell: cell, news: news)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let news = rowsToDisplay[indexPath.row]
        guard let newsURL = URL(string: news.url ?? "") else { return }
        let safariViewController = SFSafariViewController(url: newsURL)
        present(safariViewController, animated: true)
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

extension MainViewController {
    private func getNews() {
        NetworkManager.shared.fetchNews(url: NetworkManager.shared.url) { result in
            switch result {
            case .success(let info):
                self.newsRussia = info.articles ?? []
                self.rowsToDisplay = self.newsRussia
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

