//
//  InfoScreenProtocols.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

protocol InfoScreenViewModelToViewProtocol: NSObject {
    func updateCandidateName(with nameString: String)
    func updateCurrentTime(with timeString: String)
    func updateCurrentFeedTitle(with feedTitleString: String)
}

protocol InfoScreenViewToViewModelProtocol: NSObject {
    func fetchData()
}
