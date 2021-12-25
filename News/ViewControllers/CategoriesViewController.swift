//
//  CategoriesViewController.swift
//  News
//
//  Created by Анатолий Миронов on 02.12.2021.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    // MARK: - Public Properties
    var delegate: CategoriesViewControllerDelegate!
    
    // MARK: - Private Properties
    private let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
   
    // MARK: - Views
    private let searchVC = UISearchController(searchResultsController: nil)
    
    lazy private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.size.width / 2.05 - 1, height: view.frame.size.height / 4 - 1)
        return layout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.cellID)
        return collectionView
    }()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        delegate.setEmptyBadgeValue()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setCollectionViewConstraints()
        
        createSearchBar()
        collectionView.showsVerticalScrollIndicator = false
        
//        collectionView.frame = view.bounds
    }

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.cellID, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        let category = categories[indexPath.row]
        cell.configure(cell: cell, category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryVC = CategoryViewController()
        CategoriesNetworkManager.shared.category = categories[indexPath.row]
        categoryVC.navigationTitle = categories[indexPath.row].capitalized
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    // MARK: - Private Methods
    private func setCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4),
//            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Search Bar
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
//        MainNetworkManager.shared.searchKeyword = text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        MainNetworkManager.shared.searchKeyword = ""
    }
}
