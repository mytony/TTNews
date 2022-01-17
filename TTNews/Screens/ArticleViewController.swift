//
//  ArticleViewController.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/10/22.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    let url: URL
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: webView, action: #selector(WKWebView.goBack))
        let forwardBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: webView, action: #selector(WKWebView.goForward))
        setToolbarItems([backBarButton, forwardBarButton], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
}
