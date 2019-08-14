//
//  RSSOtherModel.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

class RSSOtherModel: NSObject {
    var entertainmentModel: RSSFeedModelProtocol
    var environmentModel: RSSFeedModelProtocol
    
    weak var delegate: RSSFeedModelDelegate?

    override init() {
        let entUrlStr = "http://feeds.reuters.com/reuters/entertainment"
        let entUrl = URL(string: entUrlStr)!
        entertainmentModel = RSSFeedModel(with: entUrl)
        
        let envUrlStr = "http://feeds.reuters.com/reuters/environment"
        let envUrl = URL(string: envUrlStr)!
        environmentModel = RSSFeedModel(with: envUrl)
        
        super.init()
        
        entertainmentModel.delegate = self
        environmentModel.delegate = self
    }
}

extension RSSOtherModel: RSSFeedModelProtocol {
    var isUpdating: Bool {
        return entertainmentModel.isUpdating && environmentModel.isUpdating
    }
    
    var feedData: [FeedData] {
        var data = entertainmentModel.feedData
        data.append(contentsOf: environmentModel.feedData)
        return data
    }
    
    func updateFeed() {
        entertainmentModel.updateFeed()
        environmentModel.updateFeed()
    }
}

extension RSSOtherModel: RSSFeedModelDelegate {
    func feedUpdated() {
        self.delegate?.feedUpdated()
    }
}
