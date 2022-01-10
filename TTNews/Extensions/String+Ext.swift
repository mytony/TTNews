//
//  String+Ext.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/9/22.
//

import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
