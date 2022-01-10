//
//  NewsViewController.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/4/22.
//

import UIKit

class NewsViewController: UIViewController {
    
    enum Section {
        case main
    }

    var scrollView = UIScrollView()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
       
        return stackView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Article>! = nil
    var collectionView: UICollectionView! = nil
    
    var articles: [Article] = []
    var currentCategory = ""
    var currentPage = 0
    var hasMoreArticles = true
    var isLoadingMoreArticles = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureScrollView()
        configureCollectionView()
        getArticles()
        configureDataSource()
        
        let categories = Category.allCases.map { "\($0)" }
        configureButtonsInScrollView(with: categories)
    }
    
    // MARK: - Horizontal scroll view
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false // stack view won't display without this line
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 60),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor), // disable vertical scrolling
        ])
        
        stackView.pinToEdges(of: scrollView)
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func configureButtonsInScrollView(with categories: [String]) {
        print(#function, categories)
        for i in 0..<categories.count {
            var config = UIButton.Configuration.tinted()
            config.title = categories[i].capitalizingFirstLetter()
            config.baseBackgroundColor = .systemMint
            config.baseForegroundColor = .secondaryLabel
            
            // click the button to filter out the articles from the source
            let button = UIButton(configuration: config, primaryAction: UIAction(handler: { [weak self] action in
                guard let self = self else { return }
                self.getArticles(category: categories[i], page: 1)
                self.collectionView.setContentOffset(.zero, animated: false)
            }))
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Networking
    func getArticles(category: String = "", page: Int = 1) {
        isLoadingMoreArticles = true
        Task {
            do {
                let response = try await NetworkManager.shared.getTopHeadlines(category: category, page: page)
                guard let articles = response.articles else {
                    isLoadingMoreArticles = false
                    return
                }
                updateUI(with: articles, category: category, page: page)
                isLoadingMoreArticles = false
            } catch {
                if let tnError = error as? TNError {
                    print(tnError.rawValue)
                    print("Printing the error")
                }
                isLoadingMoreArticles = false
            }
        }
    }
    
    func updateUI(with articles: [Article], category: String, page: Int) {
        if articles.count < NetworkManager.defaultPageSize {
            hasMoreArticles = false
        }
        
        if page <= currentPage {        // If it's from pressing category button
            self.articles.removeAll()
        } else if articles.isEmpty {
            return
        }
        
        currentCategory = category
        currentPage = page
        self.articles.append(contentsOf: articles)
        self.updateData(on: self.articles)
    }
}

// MARK: - Collection view, data source
extension NewsViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .absolute(44))
                                               heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ArticleCell, Article> { (cell, indexPath, article) in
            cell.set(article: article)
//            cell.titleLabel.font = .preferredFont(forTextStyle: .headline).bold
            cell.titleLabel.font = .preferredFont(forTextStyle: .headline)
            cell.titleLabel.numberOfLines = 6
            cell.contentView.backgroundColor = .systemBackground
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Article>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, article: Article) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: article)
        }
    }
    
    func updateData(on articles: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.item]
        
        guard let url = URL(string: article.url) else {
            print("Invalid URL", article.url)
            return
        }

        presentSafariVC(with: url)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreArticles, !isLoadingMoreArticles else { return }
            getArticles(category: currentCategory, page: currentPage+1)
        }
    }
}
