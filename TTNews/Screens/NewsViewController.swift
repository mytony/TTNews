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
    var currentCategory = "\(Category.general)"
    var currentPage = 0
    var hasMoreArticles = true
    var isLoadingMoreArticles = false
    var categories = Category.allCases.map { "\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureNotification()
        configureScrollView()
        configureCollectionView()
        configureDataSource()
        getArticles()
        
        configureButtonsInScrollView(with: categories)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Switch to the first category if previous category is filtered out
        // This assumes the notification arrives earlier than viewDidAppear()
        if !categories.contains(currentCategory) {
            switchToCategory(categories[0], page: 1)
        }
    }
    
    // MARK: Horizontal scroll view
    
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
        self.categories = categories
        
        // remove all subviews
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for i in 0..<categories.count {
            var config = UIButton.Configuration.tinted()
            config.title = categories[i].capitalizingFirstLetter()
            config.baseForegroundColor = .secondaryLabel
            
            // click the button to filter out the articles from the source
            let button = UIButton(configuration: config, primaryAction: UIAction(handler: { [weak self] action in
                guard let self = self else { return }
                self.switchToCategory(categories[i], page: 1)
            }))
            stackView.addArrangedSubview(button)
        }
    }
    
    func switchToCategory(_ category: String, page: Int) {
        getArticles(category: category, page: page)
        collectionView.setContentOffset(.zero, animated: false) // roll the view back to top
    }
    
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategories(notification:)), name: Notification.Name(rawValue: "CategorySettingChanged"), object: nil)
    }
    
    @objc func updateCategories(notification: Notification) {
        // access user info to get the categoreis string array
        let extraInfo = notification.userInfo
        if let categories = extraInfo?["categories"] as? [String] {
            configureButtonsInScrollView(with: categories)
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

        let articleViewController = ArticleViewController(with: url)
        articleViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleViewController, animated: true)
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
