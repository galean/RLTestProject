//
//  Extentions.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 15.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(withComment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}
