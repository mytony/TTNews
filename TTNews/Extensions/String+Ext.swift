//
//  String+Ext.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/9/22.
//
//  Source: https://stackoverflow.com/questions/26306326/swift-apply-uppercasestring-to-only-the-first-letter-of-a-string

import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
