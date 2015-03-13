//
//  WebViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Respond to action
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
       dismissViewControllerAnimated(true, completion: nil)
    }
}
