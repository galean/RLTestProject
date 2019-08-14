//
//  RSSFeedModel.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import Alamofire

protocol RSSFeedModelProtocol: NSObject {
    var delegate: RSSFeedModelDelegate? { get set }
    var isUpdating: Bool { get }
    var feedData: [FeedData] { get }
    func updateFeed()
}

protocol RSSFeedModelDelegate: NSObject {
    func feedUpdated()
}

class RSSFeedModel: NSObject {
    var isUpdating: Bool = false
    var feedData: [FeedData] = []

    fileprivate var feedUrl: URL
    
    weak var delegate: RSSFeedModelDelegate?
    
    init(with feedUrl: URL) {
        self.feedUrl = feedUrl
        
        super.init()
    }
    
    fileprivate func internalUpdateFeed() {
        // If last request is still working - then no another update is needed.
        // Another possibility is to cancel last update - but then with bad internet
        // data could be never updated.
        // Having updates queue doesn't look like a necessity, espesially with a small update interval
        guard isUpdating == false else {
            return
        }
        
        isUpdating = true
        requestFeedUpdate()
    }
    
    fileprivate func feedUpdateFinished(newFeed: [FeedData]?) {
        isUpdating = false
        
        if let feed = newFeed {
            feedData = feed
        }
        
        delegate?.feedUpdated()
    }
    
    fileprivate func requestFeedUpdate() {
        Alamofire.request(feedUrl, method: .get, parameters: nil, encoding: URLEncoding.default).validate(contentType: ["application/x-www-form-urlencoded"]).response { (response) in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let feedDataArray = self.parseHttpResultString(utf8Text)
                self.feedUpdateFinished(newFeed: feedDataArray)
            } else {
                self.feedUpdateFinished(newFeed: nil)
            }
        }
    }
    
    fileprivate func parseHttpResultString(_ httpString: String) -> [FeedData] {
        let feedArray = httpString.components(separatedBy: "<item>").dropFirst()
        
        var feedDataArray = [FeedData]()
        
        for feed in feedArray {
            let title = feed.components(separatedBy: "<title>")[1].components(separatedBy: "</title>")[0]
            let desc = feed.components(separatedBy: "<description>")[1].components(separatedBy: "&lt")[0]
            let pubDate = feed.components(separatedBy: "<pubDate>")[1].components(separatedBy: "</pubDate>")[0]
            let link = feed.components(separatedBy: "<feedburner:origLink>")[1].components(separatedBy: "</feedburner:origLink>")[0]
            let feedData = FeedData(title: title, description: desc, date: pubDate, link: link)
            feedDataArray.append(feedData)
        }
        
        return feedDataArray
    }
}

extension RSSFeedModel: RSSFeedModelProtocol {
    func updateFeed() {
        internalUpdateFeed()
    }
}
