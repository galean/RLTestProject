//
//  RSSFeedDescriptionModalVC.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit
import WebKit

protocol RSSFeedDescriptionModalVCProtocol {
    var feedDescriptionData: RSSFeedDescriptionData? {get set}
}

//MARK:- RSSFeedDescriptionModalVC
class RSSFeedDescriptionModalVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var feedDescriptionData: RSSFeedDescriptionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showURLContent()
    }
    
    fileprivate func showURLContent() {
        if let link = feedDescriptionData?.linkURL {
            webView.load(URLRequest(url: link))
            webView.navigationDelegate = self
        }
    }
}

//MARK:- RSSFeedDescriptionModalVCProtocol
extension RSSFeedDescriptionModalVC: RSSFeedDescriptionModalVCProtocol {
    
}

//MARK:- WKNavigationDelegate
extension RSSFeedDescriptionModalVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
        }
    }
}
