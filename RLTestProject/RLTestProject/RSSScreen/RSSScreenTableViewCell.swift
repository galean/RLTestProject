//
//  RSSScreenTableViewCell.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import UIKit

class RSSScreenTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(withTitle titleStr: String,
                   dateStr: String,
                   descriptionStr: String) {
        titleLabel.text = titleStr
        dateLabel.text = dateStr
        descriptionLabel.text = descriptionStr
    }
}
