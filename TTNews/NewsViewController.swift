//
//  NewsViewController.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/4/22.
//

import UIKit

class NewsViewController: UIViewController {

    var sourcesScrollView = UIScrollView()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
       
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureScrollView()
    }
    
    func configureScrollView() {
        view.addSubview(sourcesScrollView)
        sourcesScrollView.addSubview(stackView)
        
        sourcesScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false // stack view won't display without this line
        
        NSLayoutConstraint.activate([
            sourcesScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sourcesScrollView.heightAnchor.constraint(equalToConstant: 60),
            sourcesScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sourcesScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.heightAnchor.constraint(equalTo: sourcesScrollView.heightAnchor), // disable vertical scrolling
        ])
        
        stackView.pinToEdges(of: sourcesScrollView)
        configureSourceButtons(sources: ["CNN", "BBC", "台視"])
    }
    
    func configureSourceButtons(sources: [String]) {
        for i in 0..<sources.count {
            var config = UIButton.Configuration.borderedTinted()
            config.title = sources[i]
            let button = UIButton(configuration: config, primaryAction: nil)
            stackView.addArrangedSubview(button)
        }
        
    }

}

