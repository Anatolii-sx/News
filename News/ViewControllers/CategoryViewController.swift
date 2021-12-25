//
//  CategoryViewController.swift
//  News
//
//  Created by Анатолий Миронов on 25.12.2021.
//

import UIKit
import SafariServices

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Public Properties
    var navigationTitle = ""
    
    // MARK: - Private Properties
    private var news: [Article] = []
    
    // MARK: - Views
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
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
        let segmentedControl = UISegmentedControl(items: ["🇷🇺 Россия", "🇺🇸 USA"])
        segmentedControl.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.2002535182)
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0.7012882864)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16,weight: .regular),
             NSAttributedString.Key.foregroundColor: UIColor.black],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular),
             NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .selected
        )
        segmentedControl.addTarget(self, action: #selector(changeSegmentControl), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryArticleTableViewCell.self, forCellReuseIdentifier: CategoryArticleTableViewCell.cellID)
        return tableView
    }()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = navigationTitle
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        setStackViewConstraints()
        setActivityIndicatorConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self

        setupRefreshControl()
        getNews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CategoriesNetworkManager.shared.country = CategoriesCountries.ru
        CategoriesNetworkManager.shared.page = 1
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryArticleTableViewCell.cellID, for: indexPath) as? CategoryArticleTableViewCell else { return UITableViewCell() }
        
        let news = news[indexPath.row]
        cell.configure(cell: cell, news: news)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let news = news[indexPath.row]
        guard let newsURL = URL(string: news.url ?? "") else { return }
        let safariViewController = SFSafariViewController(url: newsURL)
        present(safariViewController, animated: true)
    }
    
    // MARK: - scrollViewDidEndDragging
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.height * 1.1 {
            changePage(restart: false)
            getMoreNews()
        }
    }
    
    // MARK: - Private Methods
    @objc private func changeSegmentControl() {
        changeCountry()
        clearListOfNews()
        getNews()
    }
    
    private func clearListOfNews() {
        news = []
        tableView.reloadData()
        changePage(restart: true)
    }
    
    private func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func setActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Refresh Controll
extension CategoryViewController {
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl?.addTarget(self, action: #selector(getLastNews), for: .valueChanged)
    }
    
    @objc private func getLastNews() {
        clearListOfNews()
        getNews()
    }
}

// MARK: - Private Properties Of Getting News
extension CategoryViewController {
    
    private func changeCountry() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            CategoriesNetworkManager.shared.country = CategoriesCountries.ru
        default:
            CategoriesNetworkManager.shared.country = CategoriesCountries.us
        }
    }
    
    private func changePage(restart: Bool) {
        if restart {
            CategoriesNetworkManager.shared.page = 1
        } else {
            CategoriesNetworkManager.shared.page += 1
        }
    }
    
    private func getNews() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        CategoriesNetworkManager.shared.fetchNews(url: CategoriesNetworkManager.shared.url) { result in
            switch result {
            case .success(let info):
                info.articles?.forEach { self.news.append($0) }
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getMoreNews() {
        CategoriesNetworkManager.shared.fetchNews(url: CategoriesNetworkManager.shared.url) { result in
            switch result {
            case .success(let info):
                info.articles?.forEach { article in
                    self.news.append(article)
                    let indexPath: IndexPath = IndexPath(row: (self.news.count - 1), section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .none)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
