//
//  TopStoriesViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class TopStoriesViewController: UITableViewController {
    var stories: JSON! = []
    var isFirstTime = true
    var section = ""
    // MARK: - UI properties
    @IBOutlet weak var loginBarButtonItem: UIBarButtonItem!
    let transitionManager = TransitionManager()

    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dynamic height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        // Load data
        loadStories("", page: 1)
        // Support refresh
        refreshControl?.addTarget(self, action: "refreshStories", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    // MARK: - Load data
    func loadStories(section: String, page: Int) {
        DesignerNewsService.storiesForSection(section, page: page) { (data) -> () in
            self.stories = data
            self.tableView.reloadData()
            self.view.hideLoading()
            self.refreshControl?.endRefreshing()
        }
        
        if LocalStore.getToken() == nil {
            self.loginBarButtonItem.title = "Login"
        }else {
            self.loginBarButtonItem.title = ""
        }
    }
    
    func refreshStories() {
        loadStories(section, page: 1)
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
        }else  if segue.identifier == "WebSegue" {
            let destViewController = segue.destinationViewController as WebViewController
            let indexPath = sender as NSIndexPath
            destViewController.url = stories[indexPath.row]["url"].string
            // Hide status
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            // Setup transition manager
            destViewController.transitioningDelegate = transitionManager
        }else if segue.identifier == "MenuSegue" {
            let destViewController = segue.destinationViewController as MenuViewController
            destViewController.delegate = self
        }else if segue.identifier == "LoginSegue" {
            let destViewController = segue.destinationViewController as LoginViewController
            destViewController.delegate = self
        }
    }
}

// MARK: - StoryCellDelegate
extension TopStoriesViewController: StoryCellDelegate {
    func storyCellDidTouchUpvoate(cell: StoryCell, sender: AnyObject) {
        if let token = LocalStore.getToken() {
            let story = stories[tableView.indexPathForCell(cell)!.row]
            let storyId = story["id"].int!
            DesignerNewsService.upvoteStoryWithId(storyId, token: token, response: { (successful) -> () in
                if successful {
                }
            })
            LocalStore.saveUpvoteStory(storyId)
            cell.configureStoryCell(story)
        }else {
            performSegueWithIdentifier("LoginSegue", sender: sender)
        }
    }
    
    func storyCellDidTouchComment(cell: StoryCell, sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: sender)
    }
}

// MARK: - MenuViewControllerDelegate
extension TopStoriesViewController: MenuViewControllerDelegate {
    func menuViewControllerDidTouchTop(controller: MenuViewController) {
        // setup section
        section = ""

        view.showLoading()
        loadStories(section, page: 1)
        navigationItem.title = "Top Stories"
    }
    
    func menuViewControllerDidTouchRecent(controller: MenuViewController) {
        // setup section
        section = "recent"
        
        view.showLoading()
        loadStories(section, page: 1)
        navigationItem.title = "Recent Stories"
    }
    
    func menuViewControllerDidTouchLogout(controller: MenuViewController) {
        menuViewControllerDidTouchTop(controller)
    }
    
    func menuViewControllerDidTouchLogin(controller: MenuViewController) {
        loginBarButtonItem.target?.performSegueWithIdentifier("LoginSegue", sender: loginBarButtonItem)
    }
}

// MARK: - LoginViewControllerDelegate
extension TopStoriesViewController: LoginViewControllerDelegate {
    func loginViewControllerDidLogin(controller: LoginViewController) {
        view.showLoading()
        loadStories(section, page: 1)
    }
}
