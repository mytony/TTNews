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

    var sourcesScrollView = UIScrollView()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureScrollView()
        configureCollectionView()
//        getSources()
//        getArticles()
        configureDataSource()
        getEverything()
    }
    
    // MARK: - Horizontal scroll view
    func configureScrollView() {
        view.addSubview(sourcesScrollView)
        sourcesScrollView.addSubview(stackView)
        
        sourcesScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false // stack view won't display without this line
        
        NSLayoutConstraint.activate([
            sourcesScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sourcesScrollView.heightAnchor.constraint(equalToConstant: 60),
            sourcesScrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            sourcesScrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: sourcesScrollView.heightAnchor), // disable vertical scrolling
        ])
        
        stackView.pinToEdges(of: sourcesScrollView)
        sourcesScrollView.showsHorizontalScrollIndicator = false
    }
    
    func configureSourceButtons(sources: [String]) {
        for i in 0..<sources.count {
            var config = UIButton.Configuration.tinted()
            config.title = sources[i]
            config.baseBackgroundColor = .systemMint
            config.baseForegroundColor = .secondaryLabel
            
            // click the button to filter out the articles from the source
            let button = UIButton(configuration: config, primaryAction: UIAction(handler: { [weak self] action in
                guard let self = self else { return }
                let filteredArticles = self.articles.filter { $0.source.name == sources[i] }
                self.updateData(on: filteredArticles)
            }))
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Networking
    func getEverything() {
        Task {
            do {
                var response = try await NetworkManager.shared.getTopHeadlines(page: 1)
                guard response.status == "ok" else { return }
                
                print("Finish getting article")
                
                if let articles = response.articles {
                    self.articles.append(contentsOf: articles)
                    self.updateData(on: self.articles)
                }
                
                response = try await NetworkManager.shared.getTopHeadlinesSources()
                print("Finish getting sources")
                let sourceNames = response.sources?.map { $0.name }
                if let sourceNames = sourceNames {
                    
                    // Filter out the sources that do not have articles
                    let sourcesFromArticles = self.articles.map { $0.source.name }
                    let intersectSources = Array(Set(sourcesFromArticles).intersection(sourceNames))
                    DispatchQueue.main.async {
                        self.configureSourceButtons(sources: intersectSources)
                    }
                }
            } catch {
                if let tnError = error as? TNError {
                    print(tnError.rawValue)
                }
            }
            
        }
    }
    
    func getSources() {
        print(#function)
        Task {
            do {
                let response = try await NetworkManager.shared.getTopHeadlinesSources()
                let sourceNames = response.sources?.map { $0.name }
                if let sourceNames = sourceNames {
                    print("N of sources = ", sourceNames.count)
                    print(#function, "articles has", articles.count)
                    DispatchQueue.main.async {
                        self.configureSourceButtons(sources: sourceNames)
                    }
                }
            } catch {
                if let tnError = error as? TNError {
                    print(tnError.rawValue)
                }
            }
        }
    }
    
    func getArticles() {
        print(#function)
        Task {
            do {
                let response = try await NetworkManager.shared.getTopHeadlines(page: 1)
                if let articles = response.articles {
                    self.articles.append(contentsOf: articles)
                    self.updateData(on: self.articles)
                }
            } catch {
                if let tnError = error as? TNError {
                    print(tnError.rawValue)
                }
            }
            
        }
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
}

extension NewsViewController {
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sourcesScrollView.bottomAnchor, constant: 8),
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
        print(#function)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        print(#function, "end")
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
}
