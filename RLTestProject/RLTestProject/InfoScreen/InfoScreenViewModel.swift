//
//  InfoViewModel.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation

class InfoScreenViewModel: NSObject {
    //MARK: Initialization
    unowned var view: InfoScreenViewModelToViewProtocol
    
    fileprivate let candidateName = "Andrii Plotnikov"
    fileprivate var currentDateTimeString = "" {
        didSet {
            DispatchQueue.main.async {
                self.view.updateCurrentTime(with: self.currentDateTimeString)
            }
        }
    }
    fileprivate var currentFeedTitle = "" {
        didSet {
            DispatchQueue.main.async {
                self.view.updateCurrentFeedTitle(with: self.currentFeedTitle)
            }
        }
    }
    
    fileprivate  var timer: Timer?
    
    init(with view: InfoScreenViewModelToViewProtocol) {
        self.view = view
        
        super.init()
        
        configureNotification()
    }
    
    fileprivate func configureNotification() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(handleCurrentFeedNotification(notification:)),
                           name: Notification.Name("FeedDescriptionNotification"), object: nil)
    }
    
    //MARK:- Internal methods
    fileprivate func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(updateCurrentDate),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc fileprivate func updateCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy | hh:mm:ss"
        
        let date = Date()
        currentDateTimeString = dateFormatter.string(from: date)
    }
    
    @objc fileprivate func handleCurrentFeedNotification(notification: Notification) {
        let notificationData = notification.userInfo
        
        guard let data = notificationData as? [String: String] else {
            return
        }
        
        guard let title = data["FeedTitle"] else {
            return
        }
        
        currentFeedTitle = title
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("FeedDescriptionNotification"),
                                                  object: nil)
    }
}

//MARK:- InfoScreenViewToViewModelProtocol
extension InfoScreenViewModel: InfoScreenViewToViewModelProtocol {
    func fetchData() {
        self.updateCurrentDate()
        view.updateCandidateName(with: candidateName)
        createTimer()
    }
}
