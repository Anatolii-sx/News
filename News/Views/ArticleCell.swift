//
//  NewsCell.swift
//  News
//
//  Created by Анатолий Миронов on 25.11.2021.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    static let cellID = "newsID"
    
    lazy private var photo: ArticleImageView = {
        let photo = ArticleImageView()
        photo.layer.cornerRadius = 7
        photo.layer.masksToBounds = true
        photo.backgroundColor = .purple
        return photo
    }()

    lazy private var titleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 2
        textLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        return textLabel
    }()
    
    lazy private var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 3
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .light)
        return subtitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(photo, titleLabel, subtitleLabel)
        setViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cell: UITableViewCell, news: Article) {
        titleLabel.text = news.title
        subtitleLabel.text = news.description
        photo.fetchImage(from: news.urlToImage ?? "")
    }
    
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
            photo.heightAnchor.constraint(equalToConstant: 96)
        ])
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: photo.topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
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
