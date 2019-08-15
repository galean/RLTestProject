//
//  RSSInteractor.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

enum CurrentFeedType: Int {
    case News
    case Other
}

class RSSScreenInteractor: NSObject {
    //MARK: Initialization
    unowned var presenter: RSSScreenInteractorToPresenterProtocol
    
    fileprivate var currentFeedType: CurrentFeedType = .News {
        didSet {
            switch currentFeedType {
            case .News:
                currentFeedModel = newsModel
            case .Other:
                currentFeedModel = otherModel
            }
            
            timer?.invalidate()
            handleFirstUpdate()
        }
    }
    
    fileprivate let newsModel: RSSFeedModelProtocol = RSSNewsModel()
    fileprivate let otherModel: RSSFeedModelProtocol = RSSOtherModel()
    
    fileprivate var currentFeedModel: RSSFeedModelProtocol
    
    fileprivate  var timer: Timer?
    
    init(with presenter: RSSScreenInteractorToPresenterProtocol) {
        self.presenter = presenter
        currentFeedModel = newsModel

        super.init()
        
        newsModel.delegate = self
        otherModel.delegate = self
    }
    
    fileprivate func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0,
                                     target: self,
                                     selector: #selector(updateCurrentFeed),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc fileprivate func updateCurrentFeed() {
        currentFeedModel.updateFeed()
        presenter.handleFeedUpdating(true, feedType: currentFeedType)
    }
}

//MARK:- RSSScreenPresenterToInteractorProtocol
extension RSSScreenInteractor: RSSScreenPresenterToInteractorProtocol {
    var feedTableViewNumberOfSection: Int {
        return 1
    }
    
    func handleFirstUpdate() {
        createTimer()
        DispatchQueue.global().async {
            self.updateCurrentFeed()
        }
    }
    
    func handleSegmentUpdate(at index: Int) {
        guard let feedType = CurrentFeedType(rawValue: index) else {
            print("This feed type is unhandled!")
            return
        }
        
        currentFeedType = feedType
    }
    
    func feedNumberOfRows(inSection section: Int) -> Int {
        return currentFeedModel.feedData.count
    }
    
    func feedData(for indexPath: IndexPath) -> FeedData {
        let index = indexPath.item
        let feedData = currentFeedModel.feedData

        guard index < feedData.count else {
            print("Requested item out of feed array range!")
            assert(false)
            fatalError()
        }
        
        return feedData[index]
    }
    
    func handleSelectedFeed(at index: Int) {
        let feed = currentFeedModel.feedData[index]
        let title = feed.title
        let linkURLOpt = URL(string: feed.link)
        
        guard let linkURL = linkURLOpt else {
            print("""
                     Description link is not correct!
                     Feed doesn't have description or link is corrupted.
                     """)
            return
        }
        let feedDescriptionData = RSSFeedDescriptionData(title: title, linkURL: linkURL)

        presenter.handleFeedDescription(withDescriptionData: feedDescriptionData)
    }
}

extension RSSScreenInteractor: RSSFeedModelDelegate {
    func feedUpdated() {
        presenter.requestFeedUpdate()
        presenter.handleFeedUpdating(currentFeedModel.isUpdating, feedType: currentFeedType)
    }
}
