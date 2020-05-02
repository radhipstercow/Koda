//
//  ConsumerViewItemViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/14/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import WebKit

class ConsumerViewItemViewController: UIViewController {
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var discription: UILabel!
    
    var item:Item?
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if an item has been set
        guard item != nil else {
            return
        }
        
        showItem(item!)
        
        webView = WKWebView()
        
        getVideo()
        
    }
    
    func getVideo() {
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []

        // Setting WKWebView
        webView = WKWebView(frame: CGRect(x: 0, y: 160, width: view.frame.width, height: view.frame.width * 9 / 16), configuration: webConfiguration)
        self.view.addSubview(webView)
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/\(item!.videoLink!)?playsinline=1") {
             let request:URLRequest = URLRequest(url: videoURL)
             webView.load(request)
        }
        
    }
    
    func showItem(_ i: Item) {
        
        // Set vars
        itemName.text = i.itemName
        discription.text = i.description
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let OnlinePayVC = segue.destination as? OnlinePayViewController
        
        if let OnlinePayVC = OnlinePayVC {
            
            // Set the place for the detail view controller
            OnlinePayVC.item = self.item
            
        }
    }
    
    @IBAction func buyOnlineTapped(_ sender: Any) {

        performSegue(withIdentifier: Constants.Segue.toOnlinePay, sender: self)
        
    }
}
