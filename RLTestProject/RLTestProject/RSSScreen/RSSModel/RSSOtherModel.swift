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
        entertainmentModel = RSSFeedModel(with: entUrlStr)
        
        let envUrlStr = "http://feeds.reuters.com/reuters/environment"
        environmentModel = RSSFeedModel(with: envUrlStr)
        
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
