//
//  RSSPresenter.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

class RSSScreenPresenter: NSObject {
    //MARK: Initialization
    unowned var viewController: RSSScreenPresenterToVCProtocol
    lazy var interactor: RSSScreenPresenterToInteractorProtocol = {
        return RSSScreenInteractor(with: self)
    }()
    
    init(with viewController: RSSScreenPresenterToVCProtocol) {
        self.viewController = viewController
        
        super.init()
    }
}

//MARK:- RSSScreenVCToPresenterProtocol
extension RSSScreenPresenter: RSSScreenVCToPresenterProtocol {
    var feedTableViewNumberOfSection: Int {
        return interactor.feedTableViewNumberOfSection
    }
    
    func viewDidLoad() {
        interactor.handleFirstUpdate()
    }
    
    func chosenSegment(at index: Int) {
        interactor.handleSegmentUpdate(at: index)
    }
    
    func selectedTableRow(at index: Int) {
        interactor.handleSelectedFeed(at: index)
    }
    
    func feedTableViewNumberOfRows(inSection section: Int) -> Int {
        return interactor.feedNumberOfRows(inSection: section)
    }
    
    func feedTableViewFeedData(forCellAt indexPath: IndexPath) -> FeedData {
        return interactor.feedData(for: indexPath)
    }
    
    func handleFeedDescription(withDescriptionData data: RSSFeedDescriptionData) {
        viewController.segueFeedDescription(withFeedDescriptionData: data)
    }
}

//MARK:- RSSScreenInteractorToPresenterProtocol
extension RSSScreenPresenter: RSSScreenInteractorToPresenterProtocol {
    func requestFeedUpdate() {
        viewController.reloadFeedTableView()
    }
}
