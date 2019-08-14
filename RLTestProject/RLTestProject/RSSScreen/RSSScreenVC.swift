//
//  RSSViewController.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import UIKit

class RSSScreenVC: UIViewController {
    //MARK: Initialization
    lazy var presenter: RSSScreenVCToPresenterProtocol = {
        return RSSScreenPresenter(with: self)
    }()
    
    @IBOutlet weak var tapBar: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func configureTable() {
        tableView.register(RSSScreenTableViewCell.self, forCellReuseIdentifier: "RSSScreenTableViewCell")
    }
    
    //MARK:- Buttons actions
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        presenter.chosenSegment(at: index)
    }
}

//MARK:- RSSScreenPresenterToVCProtocol
extension RSSScreenVC: RSSScreenPresenterToVCProtocol {
    func reloadFeedTableView() {
        tableView.reloadData()
    }
}

//MARK:- UITableViewDelegate
extension RSSScreenVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedTableRow(at: indexPath.row)
    }
}

//MARK:- UITableViewDataSource
extension RSSScreenVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.feedTableViewNumberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.feedTableViewNumberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedData = presenter.feedTableViewFeedData(forCellAt: indexPath)
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "RSSScreenTableViewCell",
                                                          for: indexPath)
        
        guard let feedCell = tableCell as? RSSScreenTableViewCell else {
            print("Some problem on cell dequeue")
            fatalError()
        }
        
        feedCell.configure(withTitle: feedData.title, dateStr: feedData.date,
                           descriptionStr: feedData.description)
        
        return feedCell
    }
}