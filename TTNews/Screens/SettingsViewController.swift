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
        sourcesSelectionView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let extraInfo = ["categories": sourcesSelectionView.getSelection()]
        print("post a notification with ", extraInfo)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CategorySettingChanged"), object: nil, userInfo: extraInfo)
    }
    
    func configureSourcesSection() {
        chooseSourcesLabel.text = "Choose at least one categories:"
        
        chooseSourcesLabel.translatesAutoresizingMaskIntoConstraints = false
        sourcesSelectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews(chooseSourcesLabel, sourcesSelectionView)
        
        NSLayoutConstraint.activate([
            chooseSourcesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            chooseSourcesLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            
            sourcesSelectionView.topAnchor.constraint(equalTo: chooseSourcesLabel.bottomAnchor, constant: 8),
            sourcesSelectionView.leftAnchor.constraint(equalTo: chooseSourcesLabel.leftAnchor),
            sourcesSelectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
        ])
        
        
        let categories = Category.allCases.map { "\($0)".capitalizingFirstLetter() }
        sourcesSelectionView.configureSelectionOptions(titles: categories)
    }
    
    func buttonShouldChange(newSelection: [String]) -> Bool { newSelection.count > 0 }
}
