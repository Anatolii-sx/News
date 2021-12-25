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
    private let categories = ["business", "technology", "entertainment", "health", "science", "sports", ]
   
    // MARK: - Views
    lazy private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.size.width / 2.05 - 1, height: view.frame.size.height / 4.2 - 1)
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
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0.7012882864)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Categories"
        
        delegate.setEmptyBadgeValue()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setCollectionViewConstraints()
        
        collectionView.showsVerticalScrollIndicator = false
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
