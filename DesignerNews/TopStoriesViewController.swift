//
//  TopStoriesViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class TopStoriesViewController: UITableViewController {
    // MARK: - UI properties
    let transitionManager = TransitionManager()
    var stories: JSON! = []


    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dynamic height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        // Load data
        loadStories("", page: 1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.showLoading()
    }
    
    // MARK: - Load data
    func loadStories(section: String, page: Int) {
        DesignerNewsService.storiesForSection(section, page: page) { (data) -> () in
            self.stories = data
            self.tableView.reloadData()
            self.view.hideLoading()
        }
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
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as StoryCell
        // Get data
        let story = stories[indexPath.row]
        cell.configureStoryCell(story)

        // Setup delegate
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("WebSegue", sender: indexPath)
        
    }
    
    // MARK: - Transmit data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentsSegue" {
            let destViewController = segue.destinationViewController as CommentsViewController
            let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
            destViewController.story = stories[indexPath.row]
            destViewController.comments = destViewController.story["comments"]
        }else  if segue.identifier == "WebSegue" {
            let destViewController = segue.destinationViewController as WebViewController
            let indexPath = sender as NSIndexPath
            destViewController.url = stories[indexPath.row]["url"].string
            // Hide status
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            // Setup transition manager
            destViewController.transitioningDelegate = transitionManager
        }
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
