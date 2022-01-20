//
//  ArticleCollectionViewCell.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/7/22.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    let newsImageView = UIImageView(frame: .zero)
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(article: Article) {
        if let urlToImage = article.urlToImage {
            downloadImage(fromURL: urlToImage)
        }
        titleLabel.text = article.title
    }
    
    private func configure() {
        contentView.addSubviews(newsImageView, titleLabel)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
    }
    
    func downloadImage(fromURL url: String) {
        Task {
            newsImageView.image = await NetworkManager.shared.downloadImage(from: url)
        }
    }
    
}
