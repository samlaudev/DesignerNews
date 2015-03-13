//
//  TopStoriesViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class TopStoriesViewController: UITableViewController {

    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dynamic height for cells
        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Respond to action
    @IBAction func menuButtonDidTouch(sender: AnyObject) {
        performSegueWithIdentifier("MenuSegue", sender: self)
    }
    
    @IBAction func loginButtonDidTouch(sender: AnyObject) {
        performSegueWithIdentifier("LoginSegue", sender: self)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as StoryCell
        cell.badgeImageView.image = UIImage(named: "badge-apple")
        cell.titleLabel.text = "Learn iOS design and code"
        cell.timeLabel.text = "5m"
        cell.avatarImageView.image = UIImage(named: "content-avatar-default")
        cell.upvoteButton.titleLabel?.text = "54"
        cell.commentButton.titleLabel?.text = "32"
        // Setup delegate
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("WebSegue", sender: self)
        
    }
}

// MARK: - StoryCellDelegate
extension TopStoriesViewController: StoryCellDelegate {
    func storyCellDidTouchUpvoate(cell: StoryCell, sender: AnyObject) {
    }
    
    func storyCellDidTouchComment(cell: StoryCell, sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: sender)
    }
}
