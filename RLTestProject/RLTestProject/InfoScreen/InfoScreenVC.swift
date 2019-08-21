//
//  InfoViewController.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import UIKit

class InfoScreenVC: UIViewController {
    //MARK: Initialization
    @IBOutlet weak var candidateNameLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentFeedTitleLabel: UILabel!
    
    lazy var viewModel: InfoScreenViewToViewModelProtocol = {
        return InfoScreenViewModel(with: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
    }
}

//MARK:- InfoScreenViewModelToViewProtocol
extension InfoScreenVC: InfoScreenViewModelToViewProtocol {
    func updateCurrentTime(with timeString: String) {
        self.currentDateLabel.text = timeString
    }
    
    func updateCandidateName(with nameString: String) {
        self.candidateNameLabel.text = nameString
    }
    
    func updateCurrentFeedTitle(with feedTitleString: String) {
        self.currentFeedTitleLabel.text = feedTitleString
    }
}
