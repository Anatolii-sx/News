//
//  CategoriesViewController.swift
//  News
//
//  Created by Анатолий Миронов on 02.12.2021.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    private let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    private let searchVC = UISearchController(searchResultsController: nil)
    
    lazy private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: view.frame.size.width / 2.1 - 1, height: view.frame.size.height / 3.5 - 1)
        return layout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.cellID)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setCollectionViewConstraints()
        
        createSearchBar()
        collectionView.showsVerticalScrollIndicator = false
        
//        collectionView.frame = view.bounds
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.cellID, for: indexPath) as? CategoryViewCell else { return UICollectionViewCell() }
        
        let category = categories[indexPath.row]
        cell.configure(cell: cell, category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryVC = MainViewController()
        NetworkManager.shared.category = categories[indexPath.row]
//        present(categoryVC, animated: true)
                navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    private func setCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
//            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
//        NetworkManager.shared.searchKeyword = text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        NetworkManager.shared.searchKeyword = ""
    }

    
    

}
