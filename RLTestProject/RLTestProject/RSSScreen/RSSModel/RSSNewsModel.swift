//
//  RSSNewsModel.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

class RSSNewsModel: NSObject {
    var newsModel: RSSFeedModelProtocol
    
    weak var delegate: RSSFeedModelDelegate?

    override init() {
        let newsUrlStr = "http://feeds.reuters.com/reuters/businessNews"
        newsModel = RSSFeedModel(with: newsUrlStr)
        
        super.init()
        
        newsModel.delegate = self
    }
}

extension RSSNewsModel: RSSFeedModelProtocol {
    var isUpdating: Bool {
        return newsModel.isUpdating
    }
    
    var feedData: [FeedData] {
        return newsModel.feedData
    }

    func updateFeed() {
        newsModel.updateFeed()
    }
}

extension RSSNewsModel: RSSFeedModelDelegate {
    func feedUpdated() {
        self.delegate?.feedUpdated()
    }
}
