//
//  MenuViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewControllerDidTouchTop(controller: MenuViewController)
    func menuViewControllerDidTouchRecent(controller: MenuViewController)
    func menuViewControllerDidTouchLogout(controller: MenuViewController)
    func menuViewControllerDidTouchLogin(controller: MenuViewController)
}

class MenuViewController: UIViewController {

    // MARK: - UI properties
    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var logoutLabel: UILabel!
    // MARK: - Delegate
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LocalStore.getToken() == nil {
            logoutLabel.text = "Login"
        }else {
            logoutLabel.text = "Logout"
        }
    }
    
    // MARK: - Respond to action
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        dialogView.animation = "fall"
        dialogView.animate()
    }
    
    @IBAction func topStoriesDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchTop(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func recentButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchRecent(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func logoutButtonDidTouch(sender: AnyObject) {
        if LocalStore.getToken() == nil {   // need to login
            dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.menuViewControllerDidTouchLogin(self)
        }else {                             // need to logout
            LocalStore.removeToken()
            dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.menuViewControllerDidTouchLogout(self)
        }
    }
}

