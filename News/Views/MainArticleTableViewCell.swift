//
//  NewsCell.swift
//  News
//
//  Created by Анатолий Миронов on 25.11.2021.
//

import UIKit

class MainArticleTableViewCellModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    var url: String
    
    init(title: String, subtitle: String, imageURL: URL?, url: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.url = url
    }
}

class MainArticleTableViewCell: UITableViewCell {
    static let cellID = "newsID"
    
    // MARK: - Views
    lazy private var photo: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 7
        photo.layer.masksToBounds = true
        photo.backgroundColor = .purple
        return photo
    }()

    lazy private var titleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        return textLabel
    }()
    
    lazy private var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 3
        subtitleLabel.font = .systemFont(ofSize: 11, weight: .light)
        return subtitleLabel
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(photo, titleLabel, subtitleLabel)
        setViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Cell
    func configure(cell: UITableViewCell, cellNews: MainArticleTableViewCellModel) {
        titleLabel.text = cellNews.title
        subtitleLabel.text = cellNews.subtitle
        
        
        if let data = cellNews.imageData {
            photo.image = UIImage(data: data)
        } else if let url = cellNews.imageURL {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                cellNews.imageData = data
                DispatchQueue.main.async {
                    self.photo.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    // MARK: - Set Views
    private func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    private func setViewsConstraints() {
        setPhotoConstraints()
        setTitleLabelConstraints()
        setSubtitleLabelConstraints()
    }
    
    private func setPhotoConstraints() {
        photo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            photo.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -16),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            photo.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            photo.widthAnchor.constraint(equalToConstant: 120),
            photo.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: photo.topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    private func setSubtitleLabelConstraints() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: photo.bottomAnchor),
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
        ])
    }
}
