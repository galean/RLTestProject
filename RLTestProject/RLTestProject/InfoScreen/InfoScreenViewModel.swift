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
    fileprivate var currentDateTimeString = ""
    fileprivate var currentFeedTitle = ""
    
    fileprivate  var timer: Timer?
    
    init(with view: InfoScreenViewModelToViewProtocol) {
        self.view = view
        
        super.init()
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
        
        DispatchQueue.main.async {
            self.view.updateCurrentTime(with: self.currentDateTimeString)
        }
    }
}

//MARK:- InfoScreenViewToViewModelProtocol
extension InfoScreenViewModel: InfoScreenViewToViewModelProtocol {
    func fetchData() {
        createTimer()
        view.updateCandidateName(with: candidateName)
        view.updateCurrentFeedTitle(with: currentFeedTitle)
    }
}
