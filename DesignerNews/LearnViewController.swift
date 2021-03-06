//
//  LearnViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/12/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController {
    // MARK: - UI properties
    @IBOutlet weak var bookImageView: SpringImageView!
    @IBOutlet weak var dialogView: DesignableView!
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Respond to action
    @IBAction func learnButtonDidTouch(sender: AnyObject) {
        bookImageView.animation = "pop"
        bookImageView.animate()
       
        openURL("http://designcode.io/")
    }
    
    @IBAction func twitterButtonDidTouch(sender: AnyObject) {
        openURL("http://twitter.com/mengto")
    }
    
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Helper methods
    func openURL(url: String) {
        let targetURL = NSURL(string: url)!
        UIApplication.sharedApplication().openURL(targetURL)
    }
}
