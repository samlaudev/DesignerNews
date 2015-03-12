//
//  LoginViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/12/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit
import Spring

class LoginViewController: UIViewController {

    // MARK: - UI properties
    @IBOutlet weak var dialogView: DesignableView!
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        dialogView.animation = "shake"
        dialogView.animate()
    }
}
