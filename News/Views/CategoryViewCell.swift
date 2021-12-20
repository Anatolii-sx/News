//
//  CategoryViewCell.swift
//  News
//
//  Created by Анатолий Миронов on 20.12.2021.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    static let cellID = "categoryID"
    
    lazy private var picture: UIImageView = {
        let picture = UIImageView()
        picture.layer.cornerRadius = 3
        picture.layer.masksToBounds = true
        picture.backgroundColor = .purple
        return picture
    }()
    
    lazy private var titleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 2
        textLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        textLabel.textColor = .white
        return textLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.backgroundColor = .systemRed
        addSubviews(picture, titleLabel)
        setPictureConstraints()
        setTitleLabelConstraints()
        titleLabel.text = "HOLA"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cell: UICollectionViewCell, category: String) {
        picture.image = UIImage(systemName: "phone")
        titleLabel.text = category
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setPictureConstraints() {
        picture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            picture.topAnchor.constraint(equalTo: self.topAnchor),
//            picture.rightAnchor.constraint(equalTo: self.rightAnchor),
//            picture.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            picture.leftAnchor.constraint(equalTo: self.leftAnchor),
            picture.widthAnchor.constraint(equalTo: self.widthAnchor),
            picture.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
