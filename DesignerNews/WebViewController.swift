//
//  WebViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit
import Spring

class WebViewController: UIViewController {
    // MARK: - UI properties
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    // MARK: - Model properties
    var url: String!
    var hasFinishedLoading = false
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load web view
        loadRequest(url)
        // setup delegate
        webView.delegate = self
    }

    // MARK: - Respond to action
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
       dismissViewControllerAnimated(true, completion: nil)
       // Hide status
       UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    // MARK: - Helper methods
    func loadRequest(url: String) {
        let targetURL = NSURL(string: url)!
        let request = NSURLRequest(URL: targetURL)
        webView.loadRequest(request)
    }
    
    func updateProgress() {
        if progressView.progress >= 1 {
            progressView.hidden = true
        }else {
            if hasFinishedLoading {
                progressView.progress += 0.002
            } else {
                if progressView.progress <= 0.3 {
                    progressView.progress += 0.004
                } else if progressView.progress <= 0.6 {
                    progressView.progress += 0.002
                } else if progressView.progress <= 0.9 {
                    progressView.progress += 0.001
                } else if progressView.progress <= 0.94 {
                    progressView.progress += 0.0001
                } else {
                    progressView.progress = 0.9401
                }
            }
            
            delay(0.008) { [weak self] in
                if let _self = self {
                    _self.updateProgress()
                }
            }
        }
    }
    
    // MARK: - Release resource
    deinit {
        webView.stopLoading()
        webView.delegate = nil
    }
}

// MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        hasFinishedLoading = false
        updateProgress()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        delay(1.0) { [weak self] in
            if let _self = self {
                _self.hasFinishedLoading = true
            }
        }
    }
    
}
