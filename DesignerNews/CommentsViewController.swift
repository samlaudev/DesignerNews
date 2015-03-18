//
//  CommentsViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/16/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {

    // MARK: - UI properties
    var story: JSON!
    var comments: [JSON]!
    let transitionManager = TransitionManager()
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comments = flattenComments(story["comments"].array ?? [])
        
        // Dynamic height for cells
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        // Pull down to refresh data
        refreshControl?.addTarget(self, action: "refreshStory", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    // MARK: - Load data
    func refreshStory() {
        view.showLoading()
        
        DesignerNewsService.storyForId(story["id"].int!, response: { (data) -> () in
            self.view.hideLoading()
            
            self.story = data
            self.comments = self.flattenComments(data["comments"].array ?? [])
            self.tableView.reloadData()
            
            self.refreshControl?.endRefreshing()
        })
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
        if let storyCell = cell as? StoryCell {
            storyCell.delegate = self
            storyCell.configureStoryCell(story)
        }else if let commentCell = cell as? CommentCell {
            commentCell.configureCommentCell(comments[indexPath.row - 1])
            commentCell.delegate = self
        }
        
        return cell
    }
    
    // MARK: - Pass data to ReplyViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {
            let destViewController = segue.destinationViewController as ReplyViewController
            destViewController.delegate = self
            destViewController.transitioningDelegate = transitionManager
            
            if let storyCell = sender as? StoryCell {
                destViewController.story = story
            }
            
            if let commentCell = sender as? CommentCell {
                let indexPath = tableView.indexPathForCell(commentCell)!
                let comment = comments[indexPath.row - 1]
                destViewController.comment = comment
            }
        }
    }
    
    // MARK: - Handle interaction helper methods
    func handleInteractionAfterLogin(action: ()->()) {
        if LocalStore.isHasLogin() {
            action()
        }else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    // MARK: - Business methods
    func flattenComments(comments: [JSON]) -> [JSON] {
        let flattenedComments = comments.map(commentsForComment).reduce([], +)
        return flattenedComments
    }
    
    func commentsForComment(comment: JSON) -> [JSON] {
        let comments = comment["comments"].array ?? []
        return comments.reduce([comment]) { acc, x in
            acc + self.commentsForComment(x)
        }
    }
}

// MARK: - CommentCellDelegate
extension CommentsViewController: CommonCellDelegate {
    func commonCellDelegateDidTouchUpvote(cell: CommentCell) {
        handleInteractionAfterLogin { () -> () in
            let comment = self.comments[self.tableView.indexPathForCell(cell)!.row - 1]
            let commentId = comment["id"].int!
            DesignerNewsService.upvoteCommentWithId(commentId, token: LocalStore.getToken()!, response: { (successful) -> () in
                
            })
            // Store upvote
            LocalStore.saveUpvoteComment(commentId)
            // Configure cell
            cell.configureCommentCell(comment)
        }
    }
    
    func commonCellDelegateDidTouchComment(cell: CommentCell) {
       handleInteractionAfterLogin { () -> () in
            self.performSegueWithIdentifier("ReplySegue", sender: cell)
       }
    }
}

// MARK: - StoryCellDelegate
extension CommentsViewController: StoryCellDelegate {
    func storyCellDidTouchUpvoate(cell: StoryCell, sender: AnyObject) {
        handleInteractionAfterLogin { () -> () in
            let storyId = self.story["id"].int!
            DesignerNewsService.upvoteStoryWithId(storyId, token: LocalStore.getToken()!, response: { (successful) -> () in
                if successful {
                }
            })
            LocalStore.saveUpvoteStory(storyId)
            cell.configureStoryCell(self.story)
        }
    }
    
    func storyCellDidTouchComment(cell: StoryCell, sender: AnyObject) {
        handleInteractionAfterLogin { () -> () in
            self.performSegueWithIdentifier("ReplySegue", sender: cell)
        }
    }
}

// MARK: - ReplyViewControllerDelegate
extension CommentsViewController: ReplyViewControllerDelegate {
    func replyViewControllerDidSend(controller: ReplyViewController) {
        refreshStory()
    }
}

