//
//  ReplyViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/18/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

protocol ReplyViewControllerDelegate: class {
    func replyViewControllerDidSend(controller: ReplyViewController)
}

class ReplyViewController: UIViewController {
    
    // MARK: - Model data
    var story:JSON = []
    var comment:JSON = []
    
    // MARK: - UI properties
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Delegate
    weak var delegate: ReplyViewControllerDelegate?
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    // MARK: - Respond to action
    @IBAction func sendButtonDidTouch(sender: AnyObject) {
        view.showLoading()
       
        let token = LocalStore.getToken()!
        let body = textView.text
        
        // Upload story
        if let storyId = story["id"].int {
            view.hideLoading()
            
            DesignerNewsService.replyStoryWithId(storyId, token: token, body: body, response: { (successful) -> () in
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                }else  {
                    self.showAlert()
                }
            })
        }
        
        // Upload comment
        if let commentId = comment["id"].int {
            view.hideLoading()
            
            DesignerNewsService.replyCommentWithId(commentId, token: token, body: body, response: { (successful) -> () in
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                }else {
                    self.showAlert()
                }
            })
        }
    }
    
    // MARK: - UI helper methods
    func showAlert() {
        let alertViewController = UIAlertController(title: "Oh noes.", message: "Something went wrong. Your message wasn't sent. Try again and save your text just in case.", preferredStyle: UIAlertControllerStyle.Alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertViewController, animated: true, completion: nil)
    }
}
