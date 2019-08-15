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

    fileprivate var feedUrlString: String
    
    weak var delegate: RSSFeedModelDelegate?
    
    init(with feedUrlString: String) {
        self.feedUrlString = feedUrlString
        
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
        guard let feedURL = URL(string: feedUrlString) else {
            print("""
                     Feed URL is not correct!
                     Feed won't be updated!
                     """)
            self.feedUpdateFinished(newFeed: nil)
            return
        }
        
        Alamofire.request(feedURL, method: .get, parameters: nil, encoding: URLEncoding.default).validate(contentType: ["application/x-www-form-urlencoded"]).response { (response) in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let feedDataArray = self.parseHttpResultString(utf8Text)
                self.feedUpdateFinished(newFeed: feedDataArray)
            } else {
                self.feedUpdateFinished(newFeed: nil)
            }
        }
    }
    
    fileprivate func parseHttpResultString(_ httpString: String) -> [FeedData]? {
        let feedArray = httpString.components(separatedBy: "<item>").dropFirst()
        
        var feedDataArray = [FeedData]()
        
        for feed in feedArray {
            let title = parseHttpComponent(from: feed, openningComponent: "<title>",
                                           closingComponent: "</title>")
            let desc = parseHttpComponent(from: feed, openningComponent: "<description>",
                                         closingComponent: "&lt")
            let pubDate = parseHttpComponent(from: feed, openningComponent: "<pubDate>",
                                             closingComponent: "/pubDate")
            let link = parseHttpComponent(from: feed, openningComponent: "<feedburner:origLink>",
                                          closingComponent: "</feedburner:origLink>")
            let feedData = FeedData(title: title, description: desc, date: pubDate, link: link)
            feedDataArray.append(feedData)
        }
        
        return feedDataArray
    }
    
    fileprivate func parseHttpComponent(from httpString: String,
                                        openningComponent: String,
                                        closingComponent: String) -> String {
        let firstSeparation = httpString.components(separatedBy: openningComponent)
        guard firstSeparation.count >= 2 else {
            return ""
        }
        
        let removedBeginning = firstSeparation[1]
        let secondSeparation = removedBeginning.components(separatedBy: closingComponent)
        guard secondSeparation.count >= 2 else {
            return ""
        }
        
        let internalPart = secondSeparation[0]
        return internalPart
    }
}

extension RSSFeedModel: RSSFeedModelProtocol {
    func updateFeed() {
        internalUpdateFeed()
    }
}
