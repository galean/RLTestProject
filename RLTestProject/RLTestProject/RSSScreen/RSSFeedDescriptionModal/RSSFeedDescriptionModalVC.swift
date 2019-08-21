//
//  RSSFeedDescriptionModalVC.swift
//  RLTestProject
//
//  Created by Galean Pallerman on 14.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

protocol RSSFeedDescriptionModalVCProtocol {
    var feedDescriptionData: RSSFeedDescriptionData? {get set}
}

//MARK:- RSSFeedDescriptionModalVC
class RSSFeedDescriptionModalVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var feedDescriptionData: RSSFeedDescriptionData?
    var currentRequest: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        sendFeedDescriptionOpenedNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showURLContent()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    fileprivate func showURLContent() {
        if let link = feedDescriptionData?.linkURL {
            DispatchQueue.global().async {
                self.requestURLData(with: link)
            }
        }
    }
    
    fileprivate func requestURLData(with link: URL) {
        currentRequest = Alamofire.request(link, method: .get, parameters: nil, encoding: URLEncoding.default).validate(contentType: ["application/x-www-form-urlencoded"]).response { (response) in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.showHTMLContent(utf8Text, baseLink: link)
                }
            }
        }
    }
    
    fileprivate func showHTMLContent(_ htmlString: String, baseLink link: URL) {
        self.webView.loadHTMLString(htmlString, baseURL: link)
        self.webView.navigationDelegate = self
    }
    
    fileprivate func sendFeedDescriptionOpenedNotification() {
        let feedTitle = feedDescriptionData?.title ?? ""
        NotificationCenter.default.post(name: Notification.Name("FeedDescriptionNotification"),
                                        object: nil, userInfo: ["FeedTitle": feedTitle])
    }
    
    fileprivate func sendFeedDescriptionClosedNotification() {
        NotificationCenter.default.post(name: Notification.Name("FeedDescriptionNotification"),
                                        object: nil, userInfo: ["FeedTitle": ""])
    }
    
    deinit {
        currentRequest?.cancel()
        webView.stopLoading()
        sendFeedDescriptionClosedNotification()
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
