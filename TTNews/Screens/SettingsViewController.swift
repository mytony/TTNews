//
//  SettingsViewController.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/12/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var chooseSourcesLabel = UILabel(frame: .zero)
    var sourcesSelectionView = SelectionButtonsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
//        getSources()
        configureSourcesSection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let extraInfo = ["categories": sourcesSelectionView.getSelection()]
        print("post a notification with ", extraInfo)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CategorySettingChanged"), object: nil, userInfo: extraInfo)
    }
    
    func configureSourcesSection() {
        print(#function)
        chooseSourcesLabel.text = "Choose multiple sources:"
        
        chooseSourcesLabel.translatesAutoresizingMaskIntoConstraints = false
        sourcesSelectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews(chooseSourcesLabel, sourcesSelectionView)
        
        NSLayoutConstraint.activate([
            chooseSourcesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            chooseSourcesLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            
            sourcesSelectionView.topAnchor.constraint(equalTo: chooseSourcesLabel.bottomAnchor),
            sourcesSelectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sourcesSelectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        
        let categories = Category.allCases.map { "\($0)".capitalizingFirstLetter() }
        sourcesSelectionView.configureSelectionOptions(titles: categories)
    }
    
    func getSources() {
        Task {
            do {
                let response = try await NetworkManager.shared.getTopHeadlinesSources()
                guard let sources = response.sources else { return }
                let sourceTitles = sources.compactMap { $0.id }
                DispatchQueue.main.async {
                    self.sourcesSelectionView.configureSelectionOptions(titles: sourceTitles)
                }
            } catch {
                if let tnError = error as? TNError {
                    print(tnError.rawValue)
                }
            }
        }
    }
}
