//
//  RSSProtocols.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

typealias FeedTitle = String

protocol RSSScreenVCToPresenterProtocol: NSObject {
    func viewDidLoad()
    func chosenSegment(at index: Int)
    func selectedTableRow(at index: Int)
    
    var feedTableViewNumberOfSection: Int { get }
    func feedTableViewNumberOfRows(inSection section: Int) -> Int
    func feedTableViewFeedData(forCellAt indexPath: IndexPath) -> FeedData
}

protocol RSSScreenPresenterToInteractorProtocol: NSObject {
    func handleFirstUpdate()
    func handleSegmentUpdate(at index: Int)
    func handleSelectedFeed(at index: Int)

    var feedTableViewNumberOfSection: Int { get }
    func feedNumberOfRows(inSection section: Int) -> Int
    func feedData(for indexPath: IndexPath) -> FeedData
}

protocol RSSScreenInteractorToPresenterProtocol: NSObject {
    func requestFeedUpdate()
}

protocol RSSScreenPresenterToVCProtocol: NSObject {
    func reloadFeedTableView()
}

