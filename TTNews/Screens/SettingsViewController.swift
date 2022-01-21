//
//  SettingsViewController.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/12/22.
//

import UIKit

class SettingsViewController: UIViewController, SelectionButtonsViewDelegate {
    
    var chooseSourcesLabel = UILabel(frame: .zero)
    var sourcesSelectionView = SelectionButtonsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureSourcesSection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        postCategoryNotification()
    }
    
    func postCategoryNotification() {
        let extraInfo = ["categories": sourcesSelectionView.getSelection()]
        NotificationCenter.default.post(name: NotificationNames.categorySettingChanged, object: nil, userInfo: extraInfo)
    }
    
    func configureSourcesSection() {
        chooseSourcesLabel.text = "Choose at least one categories:"
        chooseSourcesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sourcesSelectionView.delegate = self
        sourcesSelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews(chooseSourcesLabel, sourcesSelectionView)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            chooseSourcesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            chooseSourcesLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            
            sourcesSelectionView.topAnchor.constraint(equalTo: chooseSourcesLabel.bottomAnchor, constant: padding),
            sourcesSelectionView.leftAnchor.constraint(equalTo: chooseSourcesLabel.leftAnchor),
            sourcesSelectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
        ])
        
        let categories = Category.allCases.map { "\($0)".capitalizingFirstLetter() }
        sourcesSelectionView.configureSelectionOptions(titles: categories)
    }
    
    func buttonShouldChange(newSelection: [String]) -> Bool { newSelection.count > 0 }
}
