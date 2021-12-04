//
//  ViewController.swift
//  News
//
//  Created by Анатолий Миронов on 24.11.2021.
//

import UIKit
import SafariServices

@available(iOS 13.0, *)
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var news: [News] = []
    private let searchVC = UISearchController(searchResultsController: nil)
    
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
        let segmentedControl = UISegmentedControl(items: ["🇷🇺 Russia", "🇪🇺 Europe", "🇺🇸 USA"])
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
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.cellID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
//        navigationController?.title = "News"
//        navigationController?.topViewController?.title = "News"
        
        view.addSubview(stackView)
        setStackViewConstraints()
        createSearchBar()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        getNews()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.height * 1.1 {
            changePage(restart: false)
            getNews()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.cellID, for: indexPath) as? ArticleCell else { return UITableViewCell() }
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        NetworkManager.shared.searchKeyword = text
        clearListOfNews()
        getNews()
        print(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        NetworkManager.shared.searchKeyword = ""
        clearListOfNews()
        getNews()
    }
    
    @objc private func changeSegmentControl() {
        changeCountry()
        clearListOfNews()
        getNews()
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    private func clearListOfNews() {
        news = []
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
}

@available(iOS 13.0, *)
extension MainViewController {
    
    private func changeCountry() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            NetworkManager.shared.country = Countries.ru
            NetworkManager.shared.language = Language.ru
        case 1:
            NetworkManager.shared.country = Countries.eu
            NetworkManager.shared.language = Language.en
        default:
            NetworkManager.shared.country = Countries.us
            NetworkManager.shared.language = Language.en
        }
    }
    
    private func changePage(restart: Bool) {
        if restart {
            NetworkManager.shared.page = 1
        } else {
            NetworkManager.shared.page += 1
        }
    }
    
    private func getNews() {
        NetworkManager.shared.fetchNews(url: NetworkManager.shared.url) { result in
            switch result {
            case .success(let info):
                info.news?.forEach { self.news.append($0) }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

