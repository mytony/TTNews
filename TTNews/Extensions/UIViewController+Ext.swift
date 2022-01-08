//
//  UIViewController+Ext.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/8/22.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
