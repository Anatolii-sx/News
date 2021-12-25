//
//  ViewController.swift
//  News
//
//  Created by Анатолий Миронов on 24.11.2021.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Private Properties
    private var cellNews: [MainArticleTableViewCellModel] = []
    
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
        tableView.register(MainArticleTableViewCell.self, forCellReuseIdentifier: MainArticleTableViewCell.cellID)
        return tableView
    }()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Main"
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        setStackViewConstraints()
        setActivityIndicatorConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self

        setupRefreshControl()
        getNews()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainArticleTableViewCell.cellID, for: indexPath) as? MainArticleTableViewCell else { return UITableViewCell() }
        
        let cellNews = cellNews[indexPath.row]
        cell.configure(cell: cell, cellNews: cellNews)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellNews = cellNews[indexPath.row]
        guard let newsURL = URL(string: cellNews.url) else { return }
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
        cellNews = []
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
extension MainViewController {
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
extension MainViewController {
    
    private func changeCountry() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            MainNetworkManager.shared.country = Countries.ru
        default:
            MainNetworkManager.shared.country = Countries.us
        }
    }
    
    private func changePage(restart: Bool) {
        if restart {
            MainNetworkManager.shared.page = 1
        } else {
            MainNetworkManager.shared.page += 1
        }
    }
    
    private func getNews() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        MainNetworkManager.shared.fetchNews(url: MainNetworkManager.shared.url) { result in
            switch result {
            case .success(let info):
                self.cellNews = info.articles?.compactMap({
                    MainArticleTableViewCellModel(
                        title: $0.title ?? "",
                        subtitle: $0.description ?? "",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        url: $0.url ?? ""
                    )
                }) ?? []
                
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getMoreNews() {
        MainNetworkManager.shared.fetchNews(url: MainNetworkManager.shared.url) { result in
            switch result {
            case .success(let info):
                info.articles?.forEach { article in
                    self.cellNews.append(
                        MainArticleTableViewCellModel(
                            title: article.title ?? "",
                            subtitle: article.description ?? "",
                            imageURL: URL(string: article.urlToImage ?? ""),
                            url: article.url ?? ""
                        )
                    )
                    let indexPath: IndexPath = IndexPath(row: (self.cellNews.count - 1), section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .none)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

